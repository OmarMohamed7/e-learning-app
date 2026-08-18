from datetime import datetime, timezone

from pydantic import BaseModel, Field

from app.models.instructor import Instructor
from app.models.video import VideoCategory


class Course(BaseModel):
    id: str
    title: str
    description: str
    instructor: Instructor
    category: VideoCategory
    thumbnail_url: str
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
