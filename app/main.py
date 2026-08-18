from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from sqlalchemy import text

from app.api import categories, courses, videos
from app.core.config import HLS_DIR, ensure_storage_dirs
from app.core.database import engine
from app.services.hls_service import check_ffmpeg_available

ensure_storage_dirs()

app = FastAPI(title="Local HLS Video Server")

app.include_router(categories.router)
app.include_router(courses.router)
app.include_router(videos.router)

app.mount("/media", StaticFiles(directory=HLS_DIR), name="media")


@app.on_event("startup")
async def on_startup() -> None:
    try:
        check_ffmpeg_available()
    except RuntimeError as exc:
        print(f"Warning: {exc}")

    try:
        async with engine.connect() as conn:
            await conn.execute(text("SELECT 1"))
    except Exception as exc:
        print(f"Warning: could not connect to database: {exc}")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
