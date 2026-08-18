from datetime import datetime, timezone

from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base
from app.models.category import Category
from app.models.instructor import Instructor


class Course(Base):
    __tablename__ = "courses"

    id: Mapped[str] = mapped_column(primary_key=True)
    title: Mapped[str]
    description: Mapped[str]
    instructor_id: Mapped[str] = mapped_column(ForeignKey("instructors.id"))
    category_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    thumbnail_url: Mapped[str]
    created_at: Mapped[datetime] = mapped_column(default=lambda: datetime.now(timezone.utc))

    instructor: Mapped[Instructor] = relationship(lazy="joined")
    category: Mapped[Category] = relationship(lazy="joined")
