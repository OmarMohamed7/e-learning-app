from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Category(Base):
    __tablename__ = "categories"

    id: Mapped[str] = mapped_column(primary_key=True)
    name: Mapped[str]
    icon: Mapped[str | None] = mapped_column(default=None)
