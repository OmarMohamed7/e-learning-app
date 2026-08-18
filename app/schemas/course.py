from datetime import datetime

from pydantic import BaseModel

from app.models.video import VideoCategory


class InstructorOut(BaseModel):
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
    id: str
    title: str
    description: str
    instructor: InstructorOut
    category: VideoCategory
    thumbnail_url: str
    created_at: datetime


class CourseListOut(BaseModel):
    items: list[CourseOut]
    total: int


class CourseDetailOut(CourseOut):
    lessons: list[LessonOut]
    total_duration_seconds: int
