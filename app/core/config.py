from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent

STORAGE_DIR = BASE_DIR / "storage"
ORIGINALS_DIR = STORAGE_DIR / "originals"
HLS_DIR = STORAGE_DIR / "hls"
METADATA_FILE = STORAGE_DIR / "videos.json"
COURSES_METADATA_FILE = STORAGE_DIR / "courses.json"

ALLOWED_EXTENSIONS = {".mp4", ".mov", ".mkv"}
ALLOWED_CONTENT_TYPE_PREFIX = "video/"

HLS_SEGMENT_SECONDS = 6

# variant name -> (height, video bitrate, audio bitrate)
HLS_VARIANTS = {
    "240p": {"height": 240, "video_bitrate": "400k", "audio_bitrate": "96k", "bandwidth": 400_000, "resolution": "426x240"},
    "360p": {"height": 360, "video_bitrate": "600k", "audio_bitrate": "96k", "bandwidth": 600_000, "resolution": "640x360"},
    "720p": {"height": 720, "video_bitrate": "2000k", "audio_bitrate": "128k", "bandwidth": 2_000_000, "resolution": "1280x720"},
}



def ensure_storage_dirs() -> None:
    ORIGINALS_DIR.mkdir(parents=True, exist_ok=True)
    HLS_DIR.mkdir(parents=True, exist_ok=True)
