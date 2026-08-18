from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Video
from app.schemas.video import VideoOut
from app.services import video_service

router = APIRouter(prefix="/api/videos", tags=["videos"])


def _to_video_out(video: Video) -> VideoOut:
    hls_url = f"/media/{video.hls_path}" if video.hls_path else None
    return VideoOut(
        id=video.id,
        title=video.title,
        description=video.description,
        course_id=video.course_id,
        status=video.status,
        hls_url=hls_url,
        duration_seconds=video.duration_seconds,
        error=video.error,
        created_at=video.created_at,
    )


@router.get("/{video_id}", response_model=VideoOut)
async def get_video(video_id: str, db: AsyncSession = Depends(get_db)) -> VideoOut:
    video = await video_service.get_video(db, video_id)
    if video is None:
        raise HTTPException(status_code=404, detail="Video not found")
    return _to_video_out(video)
