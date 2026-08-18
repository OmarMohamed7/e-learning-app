import asyncio
import shutil
import subprocess
from pathlib import Path

from app.core.config import HLS_DIR, HLS_SEGMENT_SECONDS, HLS_VARIANTS
from app.core.database import async_session_maker
from app.models import VideoStatus
from app.services import video_service


class FFmpegNotFoundError(RuntimeError):
    pass


class TranscodeError(RuntimeError):
    pass


def check_ffmpeg_available() -> None:
    if shutil.which("ffmpeg") is None:
        raise FFmpegNotFoundError(
            "ffmpeg was not found on PATH. Install it before uploading videos."
        )


def _transcode_variant(input_path: Path, output_dir: Path, variant: dict) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    playlist_path = output_dir / "playlist.m3u8"
    segment_pattern = output_dir / "segment_%03d.ts"

    command = [
        "ffmpeg",
        "-y",
        "-i", str(input_path),
        "-vf", f"scale=-2:{variant['height']}",
        "-pix_fmt", "yuv420p",
        "-c:v", "libx264",
        "-profile:v", "main",
        "-crf", "20",
        "-sc_threshold", "0",
        "-g", "48",
        "-keyint_min", "48",
        "-b:v", variant["video_bitrate"],
        "-maxrate", variant["video_bitrate"],
        "-bufsize", variant["video_bitrate"],
        "-c:a", "aac",
        "-b:a", variant["audio_bitrate"],
        "-ar", "48000",
        "-hls_time", str(HLS_SEGMENT_SECONDS),
        "-hls_playlist_type", "vod",
        "-hls_segment_filename", str(segment_pattern),
        str(playlist_path),
    ]

    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        raise TranscodeError(f"ffmpeg failed for variant '{output_dir.name}': {result.stderr}")


def _probe_duration_seconds(input_path: Path) -> int | None:
    command = [
        "ffprobe",
        "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        str(input_path),
    ]
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    try:
        return round(float(result.stdout.strip()))
    except ValueError:
        return None


def _write_master_playlist(output_dir: Path) -> None:
    lines = ["#EXTM3U"]
    for name, variant in HLS_VARIANTS.items():
        lines.append(f"#EXT-X-STREAM-INF:BANDWIDTH={variant['bandwidth']},RESOLUTION={variant['resolution']}")
        lines.append(f"{name}/playlist.m3u8")
    (output_dir / "master.m3u8").write_text("\n".join(lines) + "\n")


def _process_video_sync(
    video_id: str, input_path: Path
) -> tuple[VideoStatus, str | None, str | None, int | None]:
    output_dir = HLS_DIR / video_id

    try:
        check_ffmpeg_available()
        for name, variant in HLS_VARIANTS.items():
            _transcode_variant(input_path, output_dir / name, variant)
        _write_master_playlist(output_dir)
    except (FFmpegNotFoundError, TranscodeError) as exc:
        return VideoStatus.FAILED, None, str(exc), None

    duration = _probe_duration_seconds(input_path)
    return VideoStatus.READY, f"{video_id}/master.m3u8", None, duration


async def process_video(video_id: str, input_path: Path) -> None:
    status, hls_path, error, duration = await asyncio.to_thread(_process_video_sync, video_id, input_path)

    async with async_session_maker() as db:
        await video_service.update_video_status(
            db,
            video_id,
            status=status,
            hls_path=hls_path,
            error=error,
            duration_seconds=duration,
        )
