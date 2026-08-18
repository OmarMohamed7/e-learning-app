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

        created_at = datetime.fromisoformat(data["created_at"])
        if created_at.tzinfo is not None:
            created_at = created_at.replace(tzinfo=None)

        session.add(
            Course(
                id=course_id,
                title=data["title"],
                description=data["description"],
                instructor_id=instructor_data["id"],
                category_id=data["category"],
                thumbnail_url=data["thumbnail_url"],
                created_at=created_at,
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

        created_at = datetime.fromisoformat(data["created_at"])
        if created_at.tzinfo is not None:
            created_at = created_at.replace(tzinfo=None)

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
                created_at=created_at,
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
