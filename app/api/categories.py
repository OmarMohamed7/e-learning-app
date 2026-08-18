from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Category
from app.schemas.category import CategoryOut

router = APIRouter(prefix="/api/categories", tags=["categories"])


@router.get("", response_model=list[CategoryOut])
async def get_categories(db: AsyncSession = Depends(get_db)) -> list[CategoryOut]:
    result = await db.execute(select(Category))
    categories = result.scalars().all()
    return [CategoryOut.model_validate(category) for category in categories]
