# Postgres Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace JSON-file persistence (`storage/courses.json`, `storage/videos.json`) and the fixed `VideoCategory` enum with a local Postgres database, while keeping video originals and HLS output on the filesystem.

**Architecture:** SQLAlchemy 2.0 async ORM models (`app/models/`) backed by Postgres via `asyncpg`, with Alembic migrations. `app/schemas/` keeps its existing role as API request/response shapes. Services and routes become `async def`, taking an `AsyncSession` from a `get_db()` FastAPI dependency. A one-time idempotent script migrates existing JSON data into the DB.

**Tech Stack:** FastAPI, SQLAlchemy 2.0 (async), asyncpg, Alembic, pydantic-settings, Postgres (local, database `mentor_stream`, already created and reachable).

**Spec:** `docs/superpowers/specs/2026-08-18-postgres-integration-design.md`

## Global Constraints

- Filesystem storage (`storage/originals/`, `storage/hls/`) is untouched — only metadata moves to Postgres.
- No automated deletion of anything under `storage/` at any point, including the old JSON files after migration.
- `DATABASE_URL` comes from `.env` via `app.core.config.Settings` (already configured: `postgresql+asyncpg://postgres:postgres@localhost:5432/mentor_stream`).
- No new test framework — this repo has no test suite today; verification is manual (documented per-task and in a final end-to-end pass), matching the existing project convention.
- No CRUD API for categories/instructors — out of scope (YAGNI, per spec).
- `python-version` floor is 3.13 (`.python-version` / `pyproject.toml` `requires-python = ">=3.13"`) — safe to use `datetime.fromisoformat` with trailing `Z`.

---

### Task 1: Fix async DB dependency + Category/Instructor ORM models

**Files:**
- Modify: `pyproject.toml` (add missing `greenlet` dependency)
- Modify: `app/models/base.py` (verify only — no change expected)
- Create: `app/models/category.py`
- Create: `app/models/instructor.py`
- Modify: `app/models/instructor.py` — wait, see step 3 (this replaces the old Pydantic `Instructor`)
- Modify: `app/models/__init__.py`

**Context:** SQLAlchemy's async engine requires the `greenlet` package, which is not currently installed (confirmed: `create_async_engine(...).connect()` raises `ValueError: the greenlet library is required`). `app/models/base.py` already exists with `Base(DeclarativeBase)` — do not recreate it, just confirm it's there.

**Interfaces:**
- Produces: `app.models.base.Base` (already exists), `app.models.category.Category` (columns: `id: str` PK, `name: str`, `icon: str | None`), `app.models.instructor.Instructor` (columns: `id: str` PK, `name: str`)

- [ ] **Step 1: Add the missing `greenlet` dependency**

```bash
uv add greenlet
```

- [ ] **Step 2: Verify async engine connects**

```bash
uv run python - <<'PY'
import asyncio
from sqlalchemy.ext.asyncio import create_async_engine

async def main():
    engine = create_async_engine("postgresql+asyncpg://postgres:postgres@localhost:5432/mentor_stream")
    async with engine.connect() as conn:
        result = await conn.exec_driver_sql("SELECT 1")
        print("DB OK:", result.scalar())
    await engine.dispose()

asyncio.run(main())
PY
```

Expected output: `DB OK: 1`

- [ ] **Step 3: Confirm `app/models/base.py` is exactly this**

```python
from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass
```

If it differs, replace it with the above.

- [ ] **Step 4: Create `app/models/category.py`**

```python
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Category(Base):
    __tablename__ = "categories"

    id: Mapped[str] = mapped_column(primary_key=True)
    name: Mapped[str]
    icon: Mapped[str | None] = mapped_column(default=None)
```

- [ ] **Step 5: Replace `app/models/instructor.py` (Pydantic → ORM)**

```python
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Instructor(Base):
    __tablename__ = "instructors"

    id: Mapped[str] = mapped_column(primary_key=True)
    name: Mapped[str]
```

- [ ] **Step 6: Write `app/models/__init__.py`**

```python
from app.models.base import Base
from app.models.category import Category
from app.models.instructor import Instructor

__all__ = ["Base", "Category", "Instructor"]
```

- [ ] **Step 7: Verify imports and table names**

```bash
uv run python -c "
from app.models import Base, Category, Instructor
print(Category.__tablename__, sorted(Category.__table__.columns.keys()))
print(Instructor.__tablename__, sorted(Instructor.__table__.columns.keys()))
"
```

Expected output:
```
categories ['icon', 'id', 'name']
instructors ['id', 'name']
```

- [ ] **Step 8: Commit**

```bash
git add pyproject.toml uv.lock app/models/base.py app/models/category.py app/models/instructor.py app/models/__init__.py
git commit -m "Add Category/Instructor ORM models and fix async SQLAlchemy dependency"
```

---

### Task 2: Course/Video ORM models

**Files:**
- Modify: `app/models/course.py` (Pydantic → ORM)
- Modify: `app/models/video.py` (Pydantic → ORM; drop `VideoCategory` enum, keep `VideoStatus`)
- Modify: `app/models/__init__.py`

**Interfaces:**
- Consumes: `app.models.base.Base`, `app.models.category.Category`, `app.models.instructor.Instructor` (Task 1)
- Produces: `app.models.course.Course` (columns: `id: str` PK, `title: str`, `description: str`, `instructor_id: str` FK→instructors, `category_id: str` FK→categories, `thumbnail_url: str`, `created_at: datetime`; relationships `instructor` and `category`, both `lazy="joined"`), `app.models.video.Video` (columns: `id: str` PK, `title: str`, `description: str`, `original_filename: str`, `course_id: str` FK→courses, `status: VideoStatus` default `PROCESSING`, `hls_path: str | None`, `duration_seconds: int | None`, `error: str | None`, `created_at: datetime`), `app.models.video.VideoStatus` enum (`PROCESSING`, `READY`, `FAILED`) — unchanged from before.

- [ ] **Step 1: Replace `app/models/course.py`**

```python
from datetime import datetime, timezone

from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base
from app.models.category import Category
from app.models.instructor import Instructor


class Course(Base):
    __tablename__ = "courses"

    id: Mapped[str] = mapped_column(primary_key=True)
    title: Mapped[str]
    description: Mapped[str]
    instructor_id: Mapped[str] = mapped_column(ForeignKey("instructors.id"))
    category_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    thumbnail_url: Mapped[str]
    created_at: Mapped[datetime] = mapped_column(default=lambda: datetime.now(timezone.utc))

    instructor: Mapped[Instructor] = relationship(lazy="joined")
    category: Mapped[Category] = relationship(lazy="joined")
```

- [ ] **Step 2: Replace `app/models/video.py`**

```python
from datetime import datetime, timezone
from enum import Enum

from sqlalchemy import Enum as SQLEnum
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class VideoStatus(str, Enum):
    PROCESSING = "processing"
    READY = "ready"
    FAILED = "failed"


class Video(Base):
    __tablename__ = "videos"

    id: Mapped[str] = mapped_column(primary_key=True)
    title: Mapped[str]
    description: Mapped[str]
    original_filename: Mapped[str]
    course_id: Mapped[str] = mapped_column(ForeignKey("courses.id"))
    status: Mapped[VideoStatus] = mapped_column(
        SQLEnum(VideoStatus, name="video_status"), default=VideoStatus.PROCESSING
    )
    hls_path: Mapped[str | None] = mapped_column(default=None)
    duration_seconds: Mapped[int | None] = mapped_column(default=None)
    error: Mapped[str | None] = mapped_column(default=None)
    created_at: Mapped[datetime] = mapped_column(default=lambda: datetime.now(timezone.utc))
```

- [ ] **Step 3: Update `app/models/__init__.py`**

```python
from app.models.base import Base
from app.models.category import Category
from app.models.course import Course
from app.models.instructor import Instructor
from app.models.video import Video, VideoStatus

__all__ = ["Base", "Category", "Course", "Instructor", "Video", "VideoStatus"]
```

- [ ] **Step 4: Verify imports, columns, and relationships**

```bash
uv run python -c "
from app.models import Base, Course, Video
print(Course.__tablename__, sorted(Course.__table__.columns.keys()))
print(Video.__tablename__, sorted(Video.__table__.columns.keys()))
print(sorted(Base.metadata.tables.keys()))
"
```

Expected output:
```
courses ['category_id', 'created_at', 'description', 'id', 'instructor_id', 'thumbnail_url', 'title']
videos ['course_id', 'created_at', 'description', 'duration_seconds', 'error', 'hls_path', 'id', 'original_filename', 'status', 'title']
['categories', 'courses', 'instructors', 'videos']
```

- [ ] **Step 5: Commit**

```bash
git add app/models/course.py app/models/video.py app/models/__init__.py
git commit -m "Add Course/Video ORM models"
```

---

### Task 3: Async DB session + startup connectivity check

**Files:**
- Modify: `app/core/database.py` (currently empty)
- Modify: `app/main.py`

**Interfaces:**
- Consumes: `app.core.config.settings.DATABASE_URL` (already exists), `app.models` package (Task 1/2, for metadata import side-effect — not directly used here but must be importable)
- Produces: `app.core.database.engine` (`AsyncEngine`), `app.core.database.async_session_maker` (`async_sessionmaker[AsyncSession]`), `app.core.database.get_db()` — async generator FastAPI dependency yielding `AsyncSession`

- [ ] **Step 1: Write `app/core/database.py`**

```python
from collections.abc import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import settings

engine = create_async_engine(settings.DATABASE_URL, echo=False)
async_session_maker = async_sessionmaker(engine, expire_on_commit=False)


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session
```

- [ ] **Step 2: Verify session maker works against the real DB**

```bash
uv run python - <<'PY'
import asyncio
from sqlalchemy import text
from app.core.database import async_session_maker

async def main():
    async with async_session_maker() as session:
        result = await session.execute(text("SELECT 1"))
        print("session OK:", result.scalar())

asyncio.run(main())
PY
```

Expected output: `session OK: 1`

- [ ] **Step 3: Add a DB connectivity check to `app/main.py` startup**

Replace the whole file with:

```python
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from sqlalchemy import text

from app.api import categories, courses, videos
from app.core.config import HLS_DIR, ensure_storage_dirs
from app.core.database import engine
from app.services.hls_service import check_ffmpeg_available

ensure_storage_dirs()

app = FastAPI(title="Local HLS Video Server")

app.include_router(categories.router)
app.include_router(courses.router)
app.include_router(videos.router)

app.mount("/media", StaticFiles(directory=HLS_DIR), name="media")


@app.on_event("startup")
async def on_startup() -> None:
    try:
        check_ffmpeg_available()
    except RuntimeError as exc:
        print(f"Warning: {exc}")

    try:
        async with engine.connect() as conn:
            await conn.execute(text("SELECT 1"))
    except Exception as exc:
        print(f"Warning: could not connect to database: {exc}")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
```

Note: this will not fully start yet — `app/api/categories.py`, `app/api/courses.py`, `app/api/videos.py` still reference the old Pydantic models and JSON-backed services until Tasks 6–9. That's expected; this task only verifies the DB session layer in isolation (Step 2 above is the real test for this task).

- [ ] **Step 4: Commit**

```bash
git add app/core/database.py app/main.py
git commit -m "Add async DB session module and startup connectivity check"
```

---

### Task 4: Alembic setup + initial migration

**Files:**
- Create: `alembic/` (via `alembic init -t async alembic`)
- Modify: `alembic/env.py`
- Modify: `alembic.ini`
- Create: `alembic/versions/<generated>_create_categories_instructors_courses_videos_tables.py` (via autogenerate)

**Interfaces:**
- Consumes: `app.models.Base` (Task 2), `app.core.config.settings.DATABASE_URL`
- Produces: four tables (`categories`, `instructors`, `courses`, `videos`) in the `mentor_stream` Postgres database

- [ ] **Step 1: Initialize Alembic with the async template**

```bash
uv run alembic init -t async alembic
```

- [ ] **Step 2: Point `alembic/env.py` at our models and settings**

Open the freshly generated `alembic/env.py`. It contains this exact structure (from the `async` template):

```python
import asyncio
from logging.config import fileConfig

from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = None
```

Make two edits:

1. Add these two imports right after `from alembic import context`:

```python
from app.core.config import settings
from app.models import Base
```

2. Change `target_metadata = None` to:

```python
target_metadata = Base.metadata
```

Then find this function further down:

```python
async def run_async_migrations() -> None:
    """In this scenario we need to create an Engine
    and associate a connection with the context.

    """

    connectable = async_engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
```

Add one line right before `connectable = async_engine_from_config(...)`:

```python
    config.set_main_option("sqlalchemy.url", settings.DATABASE_URL)
```

- [ ] **Step 3: Blank out the hardcoded URL in `alembic.ini`**

In `alembic.ini`, find the line starting with `sqlalchemy.url = ` and change it to:

```
sqlalchemy.url =
```

(leave it empty — `env.py` sets it from `settings.DATABASE_URL` at runtime)

- [ ] **Step 4: Generate the initial migration**

```bash
uv run alembic revision --autogenerate -m "create categories instructors courses videos tables"
```

- [ ] **Step 5: Inspect the generated migration file**

Open the new file under `alembic/versions/`. Confirm the `upgrade()` function contains `op.create_table(...)` calls for all four tables: `categories`, `instructors`, `courses`, `videos`, and that `courses`/`videos` have `sa.ForeignKeyConstraint` entries pointing at `instructors.id`/`categories.id` and `courses.id` respectively. If any table is missing, do not proceed — re-check Step 2 (`target_metadata` must be `Base.metadata`, and `app.models` must import all four model modules, which it does via `app/models/__init__.py`).

- [ ] **Step 6: Apply the migration**

```bash
uv run alembic upgrade head
```

- [ ] **Step 7: Verify tables exist in Postgres**

```bash
psql -h localhost -U postgres -d mentor_stream -c "\dt"
```

Expected: rows for `categories`, `instructors`, `courses`, `videos`, `alembic_version`.

- [ ] **Step 8: Commit**

```bash
git add alembic alembic.ini
git commit -m "Add Alembic migrations, create initial schema"
```

---

### Task 5: JSON → Postgres migration script

**Files:**
- Create: `scripts/migrate_json_to_postgres.py`
- Create: `scripts/__init__.py` (empty, so the script can be run as a module if needed — not required for direct execution, but keeps the directory importable)

**Interfaces:**
- Consumes: `app.core.config.COURSES_METADATA_FILE`, `app.core.config.METADATA_FILE` (existing constants), `app.core.database.async_session_maker` (Task 3), `app.models.Category`, `app.models.Instructor`, `app.models.Course`, `app.models.Video`, `app.models.VideoStatus` (Tasks 1–2)
- Produces: seeded rows in `categories`, `instructors`, `courses`, `videos` tables

- [ ] **Step 1: Write `scripts/migrate_json_to_postgres.py`**

```python
import asyncio
import json
from datetime import datetime

from app.core.config import COURSES_METADATA_FILE, METADATA_FILE
from app.core.database import async_session_maker
from app.models import Category, Course, Instructor, Video, VideoStatus

CATEGORY_SEED = [
    {"id": "business", "name": "Business", "icon": "business"},
    {"id": "finance", "name": "Finance", "icon": "finance"},
    {"id": "programming", "name": "Programming", "icon": "programming"},
    {"id": "design", "name": "Design", "icon": "design"},
]


async def seed_categories(session) -> None:
    for row in CATEGORY_SEED:
        existing = await session.get(Category, row["id"])
        if existing is None:
            session.add(Category(**row))
    await session.commit()


async def migrate_courses(session) -> None:
    if not COURSES_METADATA_FILE.exists():
        print(f"No {COURSES_METADATA_FILE} found, skipping courses.")
        return

    raw = json.loads(COURSES_METADATA_FILE.read_text())
    for course_id, data in raw.items():
        existing = await session.get(Course, course_id)
        if existing is not None:
            continue

        instructor_data = data["instructor"]
        instructor = await session.get(Instructor, instructor_data["id"])
        if instructor is None:
            instructor = Instructor(id=instructor_data["id"], name=instructor_data["name"])
            session.add(instructor)

        session.add(
            Course(
                id=course_id,
                title=data["title"],
                description=data["description"],
                instructor_id=instructor_data["id"],
                category_id=data["category"],
                thumbnail_url=data["thumbnail_url"],
                created_at=datetime.fromisoformat(data["created_at"]),
            )
        )
    await session.commit()


async def migrate_videos(session) -> None:
    if not METADATA_FILE.exists():
        print(f"No {METADATA_FILE} found, skipping videos.")
        return

    raw = json.loads(METADATA_FILE.read_text())
    for video_id, data in raw.items():
        existing = await session.get(Video, video_id)
        if existing is not None:
            continue

        session.add(
            Video(
                id=video_id,
                title=data["title"],
                description=data["description"],
                original_filename=data["original_filename"],
                course_id=data["course_id"],
                status=VideoStatus(data["status"]),
                hls_path=data["hls_path"],
                duration_seconds=data["duration_seconds"],
                error=data["error"],
                created_at=datetime.fromisoformat(data["created_at"]),
            )
        )
    await session.commit()


async def main() -> None:
    async with async_session_maker() as session:
        await seed_categories(session)
        await migrate_courses(session)
        await migrate_videos(session)

    print("Migration complete.")


if __name__ == "__main__":
    asyncio.run(main())
```

- [ ] **Step 2: Create empty `scripts/__init__.py`**

```python
```

(empty file)

- [ ] **Step 3: Run the migration**

```bash
uv run python scripts/migrate_json_to_postgres.py
```

Expected output: `Migration complete.` (with no tracebacks)

- [ ] **Step 4: Verify row counts**

```bash
psql -h localhost -U postgres -d mentor_stream -c "
SELECT
  (SELECT count(*) FROM categories) AS categories,
  (SELECT count(*) FROM instructors) AS instructors,
  (SELECT count(*) FROM courses) AS courses,
  (SELECT count(*) FROM videos) AS videos;
"
```

Expected: `categories=4`, `instructors=4`, `courses=4`, `videos=8` (matching the current `storage/courses.json` / `storage/videos.json`).

- [ ] **Step 5: Verify idempotency (re-run is a no-op)**

```bash
uv run python scripts/migrate_json_to_postgres.py
```

Then re-run the Step 4 query — counts must be unchanged.

- [ ] **Step 6: Commit**

```bash
git add scripts/migrate_json_to_postgres.py scripts/__init__.py
git commit -m "Add idempotent JSON-to-Postgres migration script"
```

---

### Task 6: Rewrite `course_service.py` (async, DB-backed)

**Files:**
- Modify: `app/services/course_service.py`

**Interfaces:**
- Consumes: `app.models.Course`, `app.models.Instructor` (Tasks 1–2), `sqlalchemy.ext.asyncio.AsyncSession`
- Produces: `async def create_course(db, *, title, description, instructor: Instructor, category_id: str, thumbnail_url) -> Course`, `async def get_course(db, course_id: str) -> Course | None`, `async def list_courses(db, category_id: str | None = None, search: str | None = None) -> list[Course]`, `async def list_popular_courses(db) -> list[Course]`, `class InvalidReferenceError(ValueError)` — raised when `category_id` doesn't exist (FK violation)

- [ ] **Step 1: Replace `app/services/course_service.py`**

```python
import random
import uuid
from itertools import groupby

from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import Course, Instructor

POPULAR_COURSES_TOTAL = 3


class InvalidReferenceError(ValueError):
    pass


async def create_course(
    db: AsyncSession,
    *,
    title: str,
    description: str,
    instructor: Instructor,
    category_id: str,
    thumbnail_url: str,
) -> Course:
    existing_instructor = await db.get(Instructor, instructor.id)
    if existing_instructor is None:
        db.add(Instructor(id=instructor.id, name=instructor.name))

    course = Course(
        id=uuid.uuid4().hex[:8],
        title=title,
        description=description,
        instructor_id=instructor.id,
        category_id=category_id,
        thumbnail_url=thumbnail_url,
    )
    db.add(course)

    try:
        await db.commit()
    except IntegrityError as exc:
        await db.rollback()
        raise InvalidReferenceError(f"Invalid category_id '{category_id}'.") from exc

    await db.refresh(course, attribute_names=["instructor", "category"])
    return course


async def get_course(db: AsyncSession, course_id: str) -> Course | None:
    return await db.get(Course, course_id)


async def list_courses(
    db: AsyncSession, category_id: str | None = None, search: str | None = None
) -> list[Course]:
    query = select(Course)
    if category_id is not None:
        query = query.where(Course.category_id == category_id)
    if search:
        query = query.where(Course.title.ilike(f"%{search.strip()}%"))
    query = query.order_by(Course.created_at.desc())

    result = await db.execute(query)
    return list(result.scalars().all())


async def list_popular_courses(db: AsyncSession) -> list[Course]:
    result = await db.execute(select(Course))
    courses = sorted(result.scalars().all(), key=lambda course: course.category_id)

    by_category = {
        category_id: list(group)
        for category_id, group in groupby(courses, key=lambda course: course.category_id)
    }

    categories = random.sample(list(by_category), k=min(POPULAR_COURSES_TOTAL, len(by_category)))
    return [random.choice(by_category[category_id]) for category_id in categories]
```

- [ ] **Step 2: Verify against the migrated data**

```bash
uv run python - <<'PY'
import asyncio
from app.core.database import async_session_maker
from app.services import course_service

async def main():
    async with async_session_maker() as db:
        courses = await course_service.list_courses(db)
        print("total courses:", len(courses))
        for c in courses:
            print(c.id, c.title, c.category.name, c.instructor.name)

        popular = await course_service.list_popular_courses(db)
        print("popular:", [c.title for c in popular])

        one = await course_service.get_course(db, courses[0].id)
        print("get_course:", one.title)

        missing = await course_service.get_course(db, "doesnotexist")
        print("missing course:", missing)

asyncio.run(main())
PY
```

Expected: prints 4 courses with real titles/category names/instructor names, a `popular` list, a `get_course` match, and `missing course: None`.

- [ ] **Step 3: Verify `InvalidReferenceError` on bad category**

```bash
uv run python - <<'PY'
import asyncio
from app.core.database import async_session_maker
from app.models import Instructor
from app.services import course_service

async def main():
    async with async_session_maker() as db:
        try:
            await course_service.create_course(
                db,
                title="Bad Category Test",
                description="",
                instructor=Instructor(id="instr-99", name="Test"),
                category_id="does-not-exist",
                thumbnail_url="https://example.com/x.png",
            )
            print("ERROR: should have raised")
        except course_service.InvalidReferenceError as exc:
            print("raised as expected:", exc)

asyncio.run(main())
PY
```

Expected: `raised as expected: Invalid category_id 'does-not-exist'.`

- [ ] **Step 4: Commit**

```bash
git add app/services/course_service.py
git commit -m "Rewrite course_service as async, Postgres-backed"
```

---

### Task 7: Rewrite `video_service.py` (async, DB-backed)

**Files:**
- Modify: `app/services/video_service.py`

**Interfaces:**
- Consumes: `app.models.Video`, `app.models.VideoStatus` (Tasks 1–2), `sqlalchemy.ext.asyncio.AsyncSession`
- Produces: `class UnsupportedFileError(ValueError)`, `def validate_upload(file: UploadFile) -> None`, `async def create_video(db, *, title, description, course_id, file) -> tuple[Video, Path]`, `async def get_video(db, video_id: str) -> Video | None`, `async def list_videos_by_course(db, course_id: str) -> list[Video]`, `async def update_video_status(db, video_id: str, *, status, hls_path=None, error=None, duration_seconds=None) -> None`

- [ ] **Step 1: Replace `app/services/video_service.py`**

```python
import shutil
import uuid
from pathlib import Path

from fastapi import UploadFile
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import ALLOWED_CONTENT_TYPE_PREFIX, ALLOWED_EXTENSIONS, ORIGINALS_DIR
from app.models import Video, VideoStatus


class UnsupportedFileError(ValueError):
    pass


def validate_upload(file: UploadFile) -> None:
    extension = Path(file.filename or "").suffix.lower()
    if extension not in ALLOWED_EXTENSIONS:
        raise UnsupportedFileError(f"Unsupported file extension '{extension}'. Allowed: {sorted(ALLOWED_EXTENSIONS)}")

    content_type = file.content_type or ""
    if not content_type.startswith(ALLOWED_CONTENT_TYPE_PREFIX):
        raise UnsupportedFileError(f"Unsupported content type '{content_type}'.")


async def create_video(
    db: AsyncSession,
    *,
    title: str,
    description: str,
    course_id: str,
    file: UploadFile,
) -> tuple[Video, Path]:
    validate_upload(file)

    video_id = uuid.uuid4().hex[:8]
    extension = Path(file.filename or "").suffix.lower()
    original_path = ORIGINALS_DIR / f"{video_id}{extension}"

    with original_path.open("wb") as out_file:
        shutil.copyfileobj(file.file, out_file)

    video = Video(
        id=video_id,
        title=title,
        description=description,
        original_filename=file.filename or original_path.name,
        course_id=course_id,
        status=VideoStatus.PROCESSING,
    )
    db.add(video)
    await db.commit()
    await db.refresh(video)

    return video, original_path


async def get_video(db: AsyncSession, video_id: str) -> Video | None:
    return await db.get(Video, video_id)


async def list_videos_by_course(db: AsyncSession, course_id: str) -> list[Video]:
    query = select(Video).where(Video.course_id == course_id).order_by(Video.created_at)
    result = await db.execute(query)
    return list(result.scalars().all())


async def update_video_status(
    db: AsyncSession,
    video_id: str,
    *,
    status: VideoStatus,
    hls_path: str | None = None,
    error: str | None = None,
    duration_seconds: int | None = None,
) -> None:
    video = await db.get(Video, video_id)
    if video is None:
        return
    video.status = status
    if hls_path is not None:
        video.hls_path = hls_path
    if error is not None:
        video.error = error
    if duration_seconds is not None:
        video.duration_seconds = duration_seconds
    await db.commit()
```

- [ ] **Step 2: Verify against the migrated data**

```bash
uv run python - <<'PY'
import asyncio
from app.core.database import async_session_maker
from app.services import video_service, course_service

async def main():
    async with async_session_maker() as db:
        courses = await course_service.list_courses(db)
        course_id = courses[0].id
        videos = await video_service.list_videos_by_course(db, course_id)
        print("videos for course:", len(videos))
        assert len(videos) > 0

        video = await video_service.get_video(db, videos[0].id)
        print("get_video:", video.title, video.status)

        missing = await video_service.get_video(db, "doesnotexist")
        print("missing video:", missing)

asyncio.run(main())
PY
```

Expected: prints a nonzero video count, a matching title/status, and `missing video: None`.

- [ ] **Step 3: Verify `update_video_status`**

```bash
uv run python - <<'PY'
import asyncio
from app.core.database import async_session_maker
from app.models import VideoStatus
from app.services import video_service, course_service

async def main():
    async with async_session_maker() as db:
        courses = await course_service.list_courses(db)
        videos = await video_service.list_videos_by_course(db, courses[0].id)
        video_id = videos[0].id
        original_status = videos[0].status

        await video_service.update_video_status(db, video_id, status=VideoStatus.FAILED, error="test error")

    async with async_session_maker() as db:
        updated = await video_service.get_video(db, video_id)
        print("status after update:", updated.status, updated.error)
        assert updated.status == VideoStatus.FAILED
        assert updated.error == "test error"

        # restore original state
        await video_service.update_video_status(db, video_id, status=original_status, error="")

    print("OK")

asyncio.run(main())
PY
```

Expected: `status after update: VideoStatus.FAILED test error` then `OK`. (This mutates and restores a real row — acceptable for a one-off manual check, not run as part of normal operation.)

- [ ] **Step 4: Commit**

```bash
git add app/services/video_service.py
git commit -m "Rewrite video_service as async, Postgres-backed"
```

---

### Task 8: Async `hls_service.process_video`

**Files:**
- Modify: `app/services/hls_service.py`

**Interfaces:**
- Consumes: `app.core.database.async_session_maker` (Task 3), `app.services.video_service.update_video_status` (Task 7, now async)
- Produces: `async def process_video(video_id: str, input_path: Path) -> None` (same name/signature shape as before, now async — called via `background_tasks.add_task`, which supports async callables)

**Context:** The ffmpeg/ffprobe subprocess logic (`_transcode_variant`, `_probe_duration_seconds`, `_write_master_playlist`, `check_ffmpeg_available`) stays exactly as-is and synchronous — it's proven working code. Only the orchestration around it changes: the whole synchronous pipeline runs inside a single `asyncio.to_thread` call, and the final DB update uses its own session (this runs as a background task after the HTTP response is already sent, so it cannot reuse a request-scoped session).

- [ ] **Step 1: Replace `app/services/hls_service.py`**

```python
import asyncio
import shutil
import subprocess
from pathlib import Path

from app.core.config import HLS_DIR, HLS_SEGMENT_SECONDS, HLS_VARIANTS
from app.core.database import async_session_maker
from app.models import VideoStatus
from app.services import video_service


class FFmpegNotFoundError(RuntimeError):
    pass


class TranscodeError(RuntimeError):
    pass


def check_ffmpeg_available() -> None:
    if shutil.which("ffmpeg") is None:
        raise FFmpegNotFoundError(
            "ffmpeg was not found on PATH. Install it before uploading videos."
        )


def _transcode_variant(input_path: Path, output_dir: Path, variant: dict) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    playlist_path = output_dir / "playlist.m3u8"
    segment_pattern = output_dir / "segment_%03d.ts"

    command = [
        "ffmpeg",
        "-y",
        "-i", str(input_path),
        "-vf", f"scale=-2:{variant['height']}",
        "-pix_fmt", "yuv420p",
        "-c:v", "libx264",
        "-profile:v", "main",
        "-crf", "20",
        "-sc_threshold", "0",
        "-g", "48",
        "-keyint_min", "48",
        "-b:v", variant["video_bitrate"],
        "-maxrate", variant["video_bitrate"],
        "-bufsize", variant["video_bitrate"],
        "-c:a", "aac",
        "-b:a", variant["audio_bitrate"],
        "-ar", "48000",
        "-hls_time", str(HLS_SEGMENT_SECONDS),
        "-hls_playlist_type", "vod",
        "-hls_segment_filename", str(segment_pattern),
        str(playlist_path),
    ]

    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        raise TranscodeError(f"ffmpeg failed for variant '{output_dir.name}': {result.stderr}")


def _probe_duration_seconds(input_path: Path) -> int | None:
    command = [
        "ffprobe",
        "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        str(input_path),
    ]
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    try:
        return round(float(result.stdout.strip()))
    except ValueError:
        return None


def _write_master_playlist(output_dir: Path) -> None:
    lines = ["#EXTM3U"]
    for name, variant in HLS_VARIANTS.items():
        lines.append(f"#EXT-X-STREAM-INF:BANDWIDTH={variant['bandwidth']},RESOLUTION={variant['resolution']}")
        lines.append(f"{name}/playlist.m3u8")
    (output_dir / "master.m3u8").write_text("\n".join(lines) + "\n")


def _process_video_sync(
    video_id: str, input_path: Path
) -> tuple[VideoStatus, str | None, str | None, int | None]:
    output_dir = HLS_DIR / video_id

    try:
        check_ffmpeg_available()
        for name, variant in HLS_VARIANTS.items():
            _transcode_variant(input_path, output_dir / name, variant)
        _write_master_playlist(output_dir)
    except (FFmpegNotFoundError, TranscodeError) as exc:
        return VideoStatus.FAILED, None, str(exc), None

    duration = _probe_duration_seconds(input_path)
    return VideoStatus.READY, f"{video_id}/master.m3u8", None, duration


async def process_video(video_id: str, input_path: Path) -> None:
    status, hls_path, error, duration = await asyncio.to_thread(_process_video_sync, video_id, input_path)

    async with async_session_maker() as db:
        await video_service.update_video_status(
            db,
            video_id,
            status=status,
            hls_path=hls_path,
            error=error,
            duration_seconds=duration,
        )
```

- [ ] **Step 2: Verify import and signature**

```bash
uv run python -c "
import asyncio, inspect
from app.services.hls_service import process_video
print('is coroutine function:', asyncio.iscoroutinefunction(process_video))
print(inspect.signature(process_video))
"
```

Expected:
```
is coroutine function: True
(video_id: str, input_path: pathlib.Path) -> None
```

Full functional verification (real ffmpeg transcode + DB status update) happens in Task 10's end-to-end pass, since it requires the API layer (Task 9) to actually trigger an upload.

- [ ] **Step 3: Commit**

```bash
git add app/services/hls_service.py
git commit -m "Make hls_service.process_video async with its own DB session"
```

---

### Task 9: API layer — schemas + routes

**Files:**
- Modify: `app/schemas/category.py`
- Modify: `app/schemas/course.py`
- Modify: `app/api/categories.py`
- Modify: `app/api/courses.py`
- Modify: `app/api/videos.py`

**Context:** Categories are now real DB rows, not enum values, so `CategoryOut.id` becomes `str`. Since category is now a queryable entity exactly like instructor, `CourseOut.category` becomes a nested `CategoryOut` object (mirroring the existing `instructor: InstructorOut` field) instead of a bare string — this is the natural shape once category has its own id/name/icon, and mirrors how `instructor` is already represented. Course *creation* still takes a plain `category_id: str` (you write with an id, you read with the full nested object — the same asymmetry `instructor_id`/`instructor_name` already has on write vs. the nested `instructor` on read).

**Interfaces:**
- Consumes: `app.core.database.get_db` (Task 3), `app.models.Category/Course/Instructor/Video/VideoStatus` (Tasks 1–2), `app.services.course_service.*` (Task 6, including `InvalidReferenceError`), `app.services.video_service.*` (Task 7), `app.services.hls_service.process_video` (Task 8)
- Produces: unchanged public route paths/methods; `GET /api/categories` now reads from DB; `POST /api/courses` and `GET /api/courses` now take `category_id` instead of `category`; `CourseOut.category` is now a `CategoryOut` object instead of a bare string

- [ ] **Step 1: Replace `app/schemas/category.py`**

```python
from pydantic import BaseModel, ConfigDict


class CategoryOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str
    icon: str | None = None
```

- [ ] **Step 2: Replace `app/schemas/course.py`**

```python
from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.schemas.category import CategoryOut


class InstructorOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str


class LessonOut(BaseModel):
    id: str
    title: str
    description: str
    video_url: str
    duration_seconds: int
    order: int


class CourseOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str
    instructor: InstructorOut
    category: CategoryOut
    thumbnail_url: str
    created_at: datetime


class CourseListOut(BaseModel):
    items: list[CourseOut]
    total: int


class CourseDetailOut(CourseOut):
    lessons: list[LessonOut]
    total_duration_seconds: int
```

- [ ] **Step 3: Replace `app/api/categories.py`**

```python
from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Category
from app.schemas.category import CategoryOut

router = APIRouter(prefix="/api/categories", tags=["categories"])


@router.get("", response_model=list[CategoryOut])
async def get_categories(db: AsyncSession = Depends(get_db)) -> list[CategoryOut]:
    result = await db.execute(select(Category))
    categories = result.scalars().all()
    return [CategoryOut.model_validate(category) for category in categories]
```

- [ ] **Step 4: Replace `app/api/videos.py`**

```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Video
from app.schemas.video import VideoOut
from app.services import video_service

router = APIRouter(prefix="/api/videos", tags=["videos"])


def _to_video_out(video: Video) -> VideoOut:
    hls_url = f"/media/{video.hls_path}" if video.hls_path else None
    return VideoOut(
        id=video.id,
        title=video.title,
        description=video.description,
        course_id=video.course_id,
        status=video.status,
        hls_url=hls_url,
        duration_seconds=video.duration_seconds,
        error=video.error,
        created_at=video.created_at,
    )


@router.get("/{video_id}", response_model=VideoOut)
async def get_video(video_id: str, db: AsyncSession = Depends(get_db)) -> VideoOut:
    video = await video_service.get_video(db, video_id)
    if video is None:
        raise HTTPException(status_code=404, detail="Video not found")
    return _to_video_out(video)
```

- [ ] **Step 5: Replace `app/api/courses.py`**

```python
from pathlib import Path
from typing import Annotated

from fastapi import APIRouter, BackgroundTasks, Depends, File, Form, HTTPException
from fastapi import UploadFile as UF
from pydantic import WithJsonSchema
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Instructor, Video
from app.schemas.course import CourseDetailOut, CourseListOut, CourseOut, LessonOut
from app.schemas.video import VideoListOut, VideoOut
from app.services import course_service, video_service
from app.services.course_service import InvalidReferenceError
from app.services.hls_service import process_video
from app.services.video_service import UnsupportedFileError

router = APIRouter(prefix="/api/courses", tags=["courses"])


def _to_lesson_out(video: Video, order: int) -> LessonOut:
    return LessonOut(
        id=video.id,
        title=video.title,
        description=video.description,
        video_url=f"/media/{video.hls_path}" if video.hls_path else "",
        duration_seconds=video.duration_seconds or 0,
        order=order,
    )


def _to_video_out(video: Video) -> VideoOut:
    hls_url = f"/media/{video.hls_path}" if video.hls_path else None
    return VideoOut(
        id=video.id,
        title=video.title,
        description=video.description,
        course_id=video.course_id,
        status=video.status,
        hls_url=hls_url,
        duration_seconds=video.duration_seconds,
        error=video.error,
        created_at=video.created_at,
    )


@router.post("", response_model=CourseOut)
async def create_course(
    title: str = Form(...),
    description: str = Form(""),
    instructor_id: str = Form(...),
    instructor_name: str = Form(...),
    category_id: str = Form(...),
    thumbnail_url: str = Form(...),
    db: AsyncSession = Depends(get_db),
) -> CourseOut:
    try:
        course = await course_service.create_course(
            db,
            title=title,
            description=description,
            instructor=Instructor(id=instructor_id, name=instructor_name),
            category_id=category_id,
            thumbnail_url=thumbnail_url,
        )
    except InvalidReferenceError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    return CourseOut.model_validate(course)


@router.get("", response_model=CourseListOut)
async def get_courses(
    category_id: str | None = None,
    search: str | None = None,
    db: AsyncSession = Depends(get_db),
) -> CourseListOut:
    courses = await course_service.list_courses(db, category_id=category_id, search=search)
    return CourseListOut(
        items=[CourseOut.model_validate(course) for course in courses],
        total=len(courses),
    )


@router.get("/popular", response_model=CourseListOut)
async def get_popular_courses(db: AsyncSession = Depends(get_db)) -> CourseListOut:
    courses = await course_service.list_popular_courses(db)
    return CourseListOut(
        items=[CourseOut.model_validate(course) for course in courses],
        total=len(courses),
    )


@router.get("/{course_id}", response_model=CourseDetailOut)
async def get_course(course_id: str, db: AsyncSession = Depends(get_db)) -> CourseDetailOut:
    course = await course_service.get_course(db, course_id)
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = await video_service.list_videos_by_course(db, course_id)
    lessons = [_to_lesson_out(video, order) for order, video in enumerate(videos)]
    total_duration_seconds = sum(lesson.duration_seconds for lesson in lessons)

    course_out = CourseOut.model_validate(course)
    return CourseDetailOut(
        **course_out.model_dump(),
        lessons=lessons,
        total_duration_seconds=total_duration_seconds,
    )


UploadFile = Annotated[UF, WithJsonSchema({"type": "string", "format": "binary"})]


@router.post("/{course_id}/videos", response_model=list[VideoOut])
async def upload_course_videos(
    course_id: str,
    background_tasks: BackgroundTasks,
    files: list[UploadFile] = File(...),
    db: AsyncSession = Depends(get_db),
) -> list[VideoOut]:
    if await course_service.get_course(db, course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    created: list[Video] = []
    for file in files:
        title = Path(file.filename or "untitled").stem
        try:
            video, original_path = await video_service.create_video(
                db,
                title=title,
                description="",
                course_id=course_id,
                file=file,
            )
        except UnsupportedFileError as exc:
            raise HTTPException(status_code=400, detail=f"{file.filename}: {exc}") from exc

        background_tasks.add_task(process_video, video.id, original_path)
        created.append(video)

    return [_to_video_out(video) for video in created]


@router.get("/{course_id}/videos", response_model=VideoListOut)
async def get_course_videos(course_id: str, db: AsyncSession = Depends(get_db)) -> VideoListOut:
    if await course_service.get_course(db, course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = await video_service.list_videos_by_course(db, course_id)
    return VideoListOut(items=[_to_video_out(video) for video in videos], total=len(videos))
```

- [ ] **Step 6: Start the server and smoke-test read endpoints**

```bash
uv run uvicorn app.main:app --port 8000 &
sleep 2
curl -s http://localhost:8000/health
echo
curl -s http://localhost:8000/api/categories
echo
curl -s http://localhost:8000/api/courses
echo
kill %1
```

Expected: `/health` returns `{"status":"ok"}`; `/api/categories` returns 4 categories with `id`/`name`/`icon`; `/api/courses` returns the 4 migrated courses, each with a nested `"category": {"id": ..., "name": ..., ...}` and `"instructor": {"id": ..., "name": ...}`.

- [ ] **Step 7: Commit**

```bash
git add app/schemas/category.py app/schemas/course.py app/api/categories.py app/api/courses.py app/api/videos.py
git commit -m "Wire API routes and schemas to async Postgres-backed services"
```

---

### Task 10: End-to-end verification

**Files:** none (verification only)

**Interfaces:**
- Consumes: the full stack from Tasks 1–9

- [ ] **Step 1: Start the server**

```bash
uv run uvicorn app.main:app --port 8000 &
sleep 2
```

- [ ] **Step 2: Confirm no startup warnings**

Check the server's stdout/stderr for `Warning: ffmpeg was not found` or `Warning: could not connect to database` — neither should appear.

- [ ] **Step 3: List courses and pick one**

```bash
curl -s http://localhost:8000/api/courses | python3 -m json.tool | head -30
```

Note one `course_id` from the output for the next step.

- [ ] **Step 4: Upload a small test video to that course**

Reuse (or regenerate) a synthetic test file the same way the original JSON-backed implementation was smoke-tested:

```bash
ffmpeg -y -f lavfi -i testsrc=duration=3:size=320x240:rate=15 -f lavfi -i sine=frequency=1000:duration=3 -c:v libx264 -c:a aac -shortest /tmp/smoke_test.mp4

curl -s -X POST "http://localhost:8000/api/courses/<COURSE_ID>/videos" \
  -F "files=@/tmp/smoke_test.mp4"
```

Replace `<COURSE_ID>` with the id from Step 3. Note the returned `video.id` — status should be `"processing"`.

- [ ] **Step 5: Poll until the video is ready**

```bash
sleep 5
curl -s http://localhost:8000/api/videos/<VIDEO_ID> | python3 -m json.tool
```

Replace `<VIDEO_ID>` with the id from Step 4. Expected: `"status": "ready"`, non-null `"hls_url"`, non-null `"duration_seconds"`. If still `"processing"`, wait a few more seconds and re-poll; transcoding is fast for a 3-second clip.

- [ ] **Step 6: Confirm the HLS output is playable/served**

```bash
curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8000<HLS_URL>"
```

Replace `<HLS_URL>` with the `hls_url` value from Step 5 (e.g. `/media/<video_id>/master.m3u8`). Expected: `200`.

- [ ] **Step 7: Confirm the course detail endpoint includes the new lesson**

```bash
curl -s http://localhost:8000/api/courses/<COURSE_ID> | python3 -m json.tool
```

Expected: the `lessons` array includes an entry for the video just uploaded, with a non-empty `video_url` and correct `duration_seconds`.

- [ ] **Step 8: Verify the row landed in Postgres directly**

```bash
psql -h localhost -U postgres -d mentor_stream -c "SELECT id, title, status, hls_path FROM videos ORDER BY created_at DESC LIMIT 1;"
```

Expected: the row for the video just uploaded, `status = ready`.

- [ ] **Step 9: Stop the server and clean up the smoke-test artifacts**

```bash
kill %1
rm /tmp/smoke_test.mp4
```

Do **not** delete anything under the project's `storage/` directory as part of this cleanup — only the `/tmp` scratch file.

- [ ] **Step 10: Final commit (if any stray changes)**

```bash
git status
```

If everything from Tasks 1–9 was already committed, this should show a clean tree (aside from the untouched `storage/courses.json`/`storage/videos.json`, which remain on disk unmodified per the spec). No commit needed here unless something was missed.
