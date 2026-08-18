import json
import random
import threading
import uuid
from itertools import groupby

from app.core.config import COURSES_METADATA_FILE
from app.models.course import Course
from app.models.instructor import Instructor
from app.models.video import VideoCategory

POPULAR_COURSES_TOTAL = 3

_lock = threading.Lock()


def _load_all() -> dict[str, Course]:
    if not COURSES_METADATA_FILE.exists():
        return {}
    raw = json.loads(COURSES_METADATA_FILE.read_text())
    return {course_id: Course.model_validate(data) for course_id, data in raw.items()}


def _save_all(courses: dict[str, Course]) -> None:
    raw = {course_id: json.loads(course.model_dump_json()) for course_id, course in courses.items()}
    COURSES_METADATA_FILE.write_text(json.dumps(raw, indent=2))


def create_course(
    *,
    title: str,
    description: str,
    instructor: Instructor,
    category: VideoCategory,
    thumbnail_url: str,
) -> Course:
    course = Course(
        id=uuid.uuid4().hex[:8],
        title=title,
        description=description,
        instructor=instructor,
        category=category,
        thumbnail_url=thumbnail_url,
    )

    with _lock:
        courses = _load_all()
        courses[course.id] = course
        _save_all(courses)

    return course


def get_course(course_id: str) -> Course | None:
    with _lock:
        return _load_all().get(course_id)


def list_courses(category: VideoCategory | None = None, search: str | None = None) -> list[Course]:
    with _lock:
        courses = list(_load_all().values())
    if category is not None:
        courses = [course for course in courses if course.category == category]
    if search:
        query = search.strip().lower()
        courses = [course for course in courses if query in course.title.lower()]
    return sorted(courses, key=lambda course: course.created_at, reverse=True)


def list_popular_courses() -> list[Course]:
    with _lock:
        courses = list(_load_all().values())

    courses.sort(key=lambda course: course.category)
    by_category = {category: list(group) for category, group in groupby(courses, key=lambda course: course.category)}

    categories = random.sample(list(by_category), k=min(POPULAR_COURSES_TOTAL, len(by_category)))
    return [random.choice(by_category[category]) for category in categories]
