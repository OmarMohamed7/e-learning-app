from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class HLSVariant(Base):
    __tablename__ = "hls_variants"

    name: Mapped[str] = mapped_column(primary_key=True)
    height: Mapped[int]
    video_bitrate: Mapped[str]
    audio_bitrate: Mapped[str]
    bandwidth: Mapped[int]
    resolution: Mapped[str]
    sort_order: Mapped[int] = mapped_column(unique=True)
