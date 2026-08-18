from fastapi import APIRouter

from app.models.video import VideoCategory
from app.schemas.category import CATEGORY_LABELS, CategoryOut

router = APIRouter(prefix="/api/categories", tags=["categories"])


@router.get("", response_model=list[CategoryOut])
def get_categories() -> list[CategoryOut]:
    return [CategoryOut(id=category, name=CATEGORY_LABELS[category], icon=CATEGORY_LABELS[category].lower()) for category in VideoCategory]
