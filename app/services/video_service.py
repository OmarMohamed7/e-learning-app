import json
import shutil
import threading
import uuid
from pathlib import Path

from fastapi import UploadFile

from app.core.config import ALLOWED_CONTENT_TYPE_PREFIX, ALLOWED_EXTENSIONS, METADATA_FILE, ORIGINALS_DIR
from app.models.video import Video, VideoStatus

_lock = threading.Lock()


class UnsupportedFileError(ValueError):
    pass


def _load_all() -> dict[str, Video]:
    if not METADATA_FILE.exists():
        return {}
    raw = json.loads(METADATA_FILE.read_text())
    return {video_id: Video.model_validate(data) for video_id, data in raw.items()}


def _save_all(videos: dict[str, Video]) -> None:
    raw = {video_id: json.loads(video.model_dump_json()) for video_id, video in videos.items()}
    METADATA_FILE.write_text(json.dumps(raw, indent=2))


def validate_upload(file: UploadFile) -> None:
    extension = Path(file.filename or "").suffix.lower()
    if extension not in ALLOWED_EXTENSIONS:
        raise UnsupportedFileError(f"Unsupported file extension '{extension}'. Allowed: {sorted(ALLOWED_EXTENSIONS)}")

    content_type = file.content_type or ""
    if not content_type.startswith(ALLOWED_CONTENT_TYPE_PREFIX):
        raise UnsupportedFileError(f"Unsupported content type '{content_type}'.")


def create_video(
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

    video = Video(
        id=video_id,
        title=title,
        description=description,
        original_filename=file.filename or original_path.name,
        course_id=course_id,
        status=VideoStatus.PROCESSING,
    )

    with _lock:
        videos = _load_all()
        videos[video_id] = video
        _save_all(videos)

    return video, original_path


def get_video(video_id: str) -> Video | None:
    with _lock:
        return _load_all().get(video_id)


def list_videos_by_course(course_id: str) -> list[Video]:
    with _lock:
        videos = [video for video in _load_all().values() if video.course_id == course_id]
    return sorted(videos, key=lambda video: video.created_at)


def update_video_status(
    video_id: str,
    *,
    status: VideoStatus,
    hls_path: str | None = None,
    error: str | None = None,
    duration_seconds: int | None = None,
) -> None:
    with _lock:
        videos = _load_all()
        video = videos.get(video_id)
        if video is None:
            return
        video.status = status
        if hls_path is not None:
            video.hls_path = hls_path
        if error is not None:
            video.error = error
        if duration_seconds is not None:
            video.duration_seconds = duration_seconds
        videos[video_id] = video
        _save_all(videos)
