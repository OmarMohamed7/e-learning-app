from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Instructor(Base):
    __tablename__ = "instructors"

    id: Mapped[str] = mapped_column(primary_key=True)
    name: Mapped[str]
