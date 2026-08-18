from datetime import datetime

from pydantic import BaseModel

from app.models.video import VideoStatus


class VideoOut(BaseModel):
    id: str
    title: str
    description: str
    course_id: str
    status: VideoStatus
    hls_url: str | None = None
    duration_seconds: int | None = None
    error: str | None = None
    created_at: datetime


class VideoListOut(BaseModel):
    items: list[VideoOut]
    total: int
