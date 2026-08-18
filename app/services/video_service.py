import shutil
import uuid
from datetime import datetime, timezone
from pathlib import Path

from fastapi import UploadFile
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import ALLOWED_CONTENT_TYPE_PREFIX, ALLOWED_EXTENSIONS, ORIGINALS_DIR
from app.models import Video, VideoStatus


class UnsupportedFileError(ValueError):
    pass


def validate_upload(file: UploadFile) -> None:
    extension = Path(file.filename or "").suffix.lower()
    if extension not in ALLOWED_EXTENSIONS:
        raise UnsupportedFileError(f"Unsupported file extension '{extension}'. Allowed: {sorted(ALLOWED_EXTENSIONS)}")

    content_type = file.content_type or ""
    if not content_type.startswith(ALLOWED_CONTENT_TYPE_PREFIX):
        raise UnsupportedFileError(f"Unsupported content type '{content_type}'.")


async def create_video(
    db: AsyncSession,
    *,
    title: str,
    description: str,
    course_id: str,
    file: UploadFile,
) -> tuple[Video, Path]:
    validate_upload(file)

    video_id = uuid.uuid4().hex[:8]
    extension = Path(file.filename or "").suffix.lower()
    original_path = ORIGINALS_DIR / f"{video_id}{extension}"

    with original_path.open("wb") as out_file:
        shutil.copyfileobj(file.file, out_file)

    # Use UTC time with timezone stripped to match TIMESTAMP WITHOUT TIME ZONE column
    created_at = datetime.now(timezone.utc).replace(tzinfo=None)

    video = Video(
        id=video_id,
        title=title,
        description=description,
        original_filename=file.filename or original_path.name,
        course_id=course_id,
        status=VideoStatus.PROCESSING,
        created_at=created_at,
    )
    db.add(video)
    await db.commit()
    await db.refresh(video)

    return video, original_path


async def get_video(db: AsyncSession, video_id: str) -> Video | None:
    return await db.get(Video, video_id)


async def list_videos_by_course(db: AsyncSession, course_id: str) -> list[Video]:
    query = select(Video).where(Video.course_id == course_id).order_by(Video.created_at)
    result = await db.execute(query)
    return list(result.scalars().all())


async def update_video_status(
    db: AsyncSession,
    video_id: str,
    *,
    status: VideoStatus,
    hls_path: str | None = None,
    error: str | None = None,
    duration_seconds: int | None = None,
) -> None:
    video = await db.get(Video, video_id)
    if video is None:
        return
    video.status = status
    if hls_path is not None:
        video.hls_path = hls_path
    if error is not None:
        video.error = error
    if duration_seconds is not None:
        video.duration_seconds = duration_seconds
    await db.commit()
