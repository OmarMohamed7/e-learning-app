from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict


BASE_DIR = Path(__file__).resolve().parent.parent.parent

STORAGE_DIR = BASE_DIR / "storage"
ORIGINALS_DIR = STORAGE_DIR / "originals"
HLS_DIR = STORAGE_DIR / "hls"
METADATA_FILE = STORAGE_DIR / "videos.json"
COURSES_METADATA_FILE = STORAGE_DIR / "courses.json"

ALLOWED_EXTENSIONS = {".mp4", ".mov", ".mkv"}
ALLOWED_CONTENT_TYPE_PREFIX = "video/"

HLS_SEGMENT_SECONDS = 6


def ensure_storage_dirs() -> None:
    ORIGINALS_DIR.mkdir(parents=True, exist_ok=True)
    HLS_DIR.mkdir(parents=True, exist_ok=True)


class Settings(BaseSettings):
    DATABASE_URL: str
    
    model_config = SettingsConfigDict(
        env_file=BASE_DIR / ".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

settings = Settings() # type: ignore