import random
import uuid
from datetime import datetime, timezone
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

    # Use UTC time with timezone stripped to match TIMESTAMP WITHOUT TIME ZONE column
    created_at = datetime.now(timezone.utc).replace(tzinfo=None)

    course = Course(
        id=uuid.uuid4().hex[:8],
        title=title,
        description=description,
        instructor_id=instructor.id,
        category_id=category_id,
        thumbnail_url=thumbnail_url,
        created_at=created_at,
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
