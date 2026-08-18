from pydantic import BaseModel

from app.models.video import VideoCategory

CATEGORY_LABELS: dict[VideoCategory, str] = {
    VideoCategory.BUSINESS: "Business",
    VideoCategory.FINANCE: "Finance",
    VideoCategory.PROGRAMMING: "Programming",
    VideoCategory.DESIGN: "Design",
}


class CategoryOut(BaseModel):
    id: VideoCategory
    name: str
    icon: str | None = None
