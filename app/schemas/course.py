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
