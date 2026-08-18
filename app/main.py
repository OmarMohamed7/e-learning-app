from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.api import categories, courses, videos
from app.core.config import HLS_DIR, ensure_storage_dirs
from app.services.hls_service import check_ffmpeg_available

ensure_storage_dirs()

app = FastAPI(title="Local HLS Video Server")

app.include_router(categories.router)
app.include_router(courses.router)
app.include_router(videos.router)

app.mount("/media", StaticFiles(directory=HLS_DIR), name="media")


@app.on_event("startup")
def on_startup() -> None:
    try:
        check_ffmpeg_available()
    except RuntimeError as exc:
        print(f"Warning: {exc}")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
