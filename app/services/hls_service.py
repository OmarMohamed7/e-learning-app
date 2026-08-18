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

        # Overwrite the output files if they already exist.
        "-y",

        # Input video file.
        "-i", str(input_path),

        # Resize the video while preserving the original aspect ratio.
        # -2 means FFmpeg automatically calculates an even width.
        # The height is the target HLS variant resolution.
        "-vf", f"scale=-2:{variant['height']}",

        # Use YUV 4:2:0 pixel format for broad device/browser compatibility.
        "-pix_fmt", "yuv420p",

        # Encode the video using H.264, which is widely supported
        # by mobile devices, browsers, and HLS players.
        "-c:v", "libx264",

        # Use the H.264 Main profile for compatibility with a wide
        # range of playback devices.
        "-profile:v", "main",

        # Constant Rate Factor controls the visual quality.
        # Lower values generally mean higher quality and larger files.
        "-crf", "20",

        # Disable scene-change based keyframe insertion.
        # This helps keep keyframe placement predictable for HLS segments.
        "-sc_threshold", "0",

        # Set the maximum GOP size to 48 frames.
        # This controls how frequently keyframes are inserted.
        "-g", "48",

        # Set the minimum GOP size to 48 frames.
        # Together with -g and -sc_threshold 0, this keeps keyframes
        # at predictable intervals.
        "-keyint_min", "48",

        # Target video bitrate for this quality/resolution variant.
        "-b:v", variant["video_bitrate"],

        # Maximum allowed video bitrate.
        # Prevents bitrate from exceeding the target too much.
        "-maxrate", variant["video_bitrate"],

        # Rate-control buffer size.
        # Helps control bitrate fluctuations during encoding.
        "-bufsize", variant["video_bitrate"],

        # Encode the audio using AAC, a standard audio codec for HLS.
        "-c:a", "aac",

        # Target audio bitrate.
        "-b:a", variant["audio_bitrate"],

        # Audio sample rate: 48 kHz.
        "-ar", "48000",

        # Target duration of each HLS segment in seconds.
        # Example: 6 seconds means the video is split into ~6-second chunks.
        "-hls_time", str(HLS_SEGMENT_SECONDS),

        # Mark the playlist as Video-on-Demand.
        # FFmpeg will generate a complete playlist instead of a live playlist.
        "-hls_playlist_type", "vod",

        # Pattern used to generate the HLS media segments.
        # Example:
        # segment_000.ts
        # segment_001.ts
        # segment_002.ts
        "-hls_segment_filename", str(segment_pattern),

        # Output HLS playlist (.m3u8).
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
