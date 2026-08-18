from datetime import datetime, timezone
from enum import Enum

from pydantic import BaseModel, Field


class VideoCategory(str, Enum):
    BUSINESS = "business"
    FINANCE = "finance"
    PROGRAMMING = "programming"
    DESIGN = "design"


class VideoStatus(str, Enum):
    PROCESSING = "processing"
    READY = "ready"
    FAILED = "failed"


class Video(BaseModel):
    id: str
    title: str
    description: str
    original_filename: str
    course_id: str
    status: VideoStatus = VideoStatus.PROCESSING
    hls_path: str | None = None
    duration_seconds: int | None = None
    error: str | None = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
