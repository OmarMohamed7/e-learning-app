# Postgres Integration — Design

## Context

The app currently persists course/video metadata in flat JSON files
(`storage/courses.json`, `storage/videos.json`) guarded by a
`threading.Lock`, and stores category as a fixed Python enum
(`VideoCategory`). Video originals and transcoded HLS output live on
the filesystem (`storage/originals/`, `storage/hls/`).

We're introducing a local Postgres database (`mentor_stream`) to hold
structured metadata, while binary media stays on the filesystem.

## Decision: what goes where

- **Filesystem** (unchanged): `storage/originals/*` (uploaded source
  files) and `storage/hls/<video_id>/...` (transcoded variants +
  playlists), served via the existing `/media` StaticFiles mount.
  Postgres is not a good fit for large binaries — it bloats the DB,
  hurts backup/replication, and gains nothing over a filesystem or
  object store for this access pattern.
- **Postgres**: everything currently in `courses.json` /
  `videos.json`, plus categories (promoted from a fixed enum to a
  table) and instructors (promoted from an embedded value to a real
  entity, since `Instructor` already carries a stable `id`).

## Stack

- SQLAlchemy 2.0 (async) + Alembic for migrations
- `asyncpg` driver
- `pydantic-settings` for config (`DATABASE_URL` from `.env`, already
  set up: `postgresql+asyncpg://postgres:postgres@localhost:5432/mentor_stream`)
- All DB-touching routes and service functions become `async def`

## Schema

```
categories   id (PK, e.g. "business"), name, icon
instructors  id (PK), name
courses      id (PK), title, description, instructor_id (FK→instructors),
             category_id (FK→categories), thumbnail_url, created_at
videos       id (PK), title, description, original_filename,
             course_id (FK→courses), status, hls_path, duration_seconds,
             error, created_at
```

FKs give us referential integrity the JSON version never had (e.g. a
video can no longer reference a nonexistent course).

## Code layout

- `app/models/base.py` — `Base(DeclarativeBase)` (already created)
- `app/models/instructor.py`, `app/models/category.py`,
  `app/models/course.py`, `app/models/video.py` — become SQLAlchemy
  ORM classes (`Instructor`, `Category`, `Course`, `Video`),
  **replacing** the current Pydantic domain models. `VideoStatus`
  enum stays as a Python enum, used as the column type
  (`SQLEnum(VideoStatus)`).
- `app/schemas/*.py` — unchanged in role: API request/response shapes
  (`CourseOut`, `VideoOut`, `CategoryOut`, etc.). Routes build these
  from ORM objects, e.g. `CourseOut.model_validate(course)` with
  `model_config = ConfigDict(from_attributes=True)`.
- `app/core/database.py` — async engine (from `settings.DATABASE_URL`),
  `async_sessionmaker`, `get_db()` FastAPI dependency yielding an
  `AsyncSession` per request.
- `alembic/` — migration environment using the async-aware `env.py`
  recipe; first migration creates the four tables.
- `scripts/migrate_json_to_postgres.py` — one-time script: seeds
  `categories` from the current `VideoCategory` enum + `CATEGORY_LABELS`,
  reads `storage/courses.json` and `storage/videos.json`, dedupes
  instructors by id, inserts courses and videos preserving original
  ids and `created_at` timestamps. Run once after `alembic upgrade head`.
  Idempotent (skip rows whose id already exists) so it's safe to re-run.
- `app/services/course_service.py`, `app/services/video_service.py` —
  rewritten as async functions taking an `AsyncSession` (via
  `Depends(get_db)` at the route, passed down); JSON load/save and
  `threading.Lock` removed entirely.
- `app/services/hls_service.process_video` — becomes `async def`;
  blocking `subprocess.run` calls (ffmpeg/ffprobe) move to
  `asyncio.to_thread`. Since this runs as a `BackgroundTasks` job
  *after* the response is sent, it can't reuse the request's session —
  it opens its own via `async_sessionmaker()` as a context manager.
- `app/core/config.py` — `METADATA_FILE` / `COURSES_METADATA_FILE`
  constants and `Settings`/`DATABASE_URL` coexist; the JSON constants
  become unused by the app (kept only as historical reference, or
  removed once the migration script no longer needs them — the script
  reads them directly via `app.core.config`).

## What we will not touch

`storage/courses.json` and `storage/videos.json` are left on disk,
untouched, after migration. No automated deletion of anything under
`storage/`.

## Error handling

- Startup: attempt a lightweight connectivity check (`SELECT 1`)
  against Postgres, mirroring the existing `check_ffmpeg_available()`
  warn-don't-crash pattern — print a clear warning if unreachable
  rather than hard-failing uvicorn startup.
- FK violations (e.g. bad `category_id`/`instructor_id` on course
  create) surface as `HTTPException(400)` with the DB error message,
  not a raw 500.
- `get_course`/`get_video` 404s stay exactly as they behave today.

## Testing / verification

No test suite exists in the repo today, so verification is manual,
mirroring the smoke test used when the app was first built:

1. `alembic upgrade head` against the local `mentor_stream` DB.
2. Run `scripts/migrate_json_to_postgres.py`, confirm row counts match
   the JSON files (4 courses, 8 videos, 4 categories, 4 instructors).
3. Start the server, hit `/api/categories`, `/api/courses`,
   `/api/courses/{id}`, `/api/courses/{id}/videos` and confirm parity
   with pre-migration responses.
4. Upload a new video end-to-end (create course → upload → poll status
   → confirm `ready` + playable `hls_url`), confirming the async
   background transcode path still updates status correctly.

## Out of scope (YAGNI)

- No CRUD API for categories/instructors (categories are DB rows now,
  but nothing today asks to create/edit them via API — that's a
  future ask if it comes up).
- No ORM-level connection pooling tuning beyond SQLAlchemy defaults.
- No automated test suite (matches current repo state).
