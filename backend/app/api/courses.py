from pathlib import Path
from typing import Annotated

from fastapi import APIRouter, BackgroundTasks, Depends, File, Form, HTTPException
from fastapi import UploadFile as UF
from pydantic import WithJsonSchema
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models import Instructor, Video
from app.schemas.course import CourseDetailOut, CourseListOut, CourseOut, LessonOut
from app.schemas.video import VideoListOut, VideoOut
from app.services import course_service, video_service
from app.services.course_service import InvalidReferenceError
from app.services.hls_service import process_video
from app.services.video_service import UnsupportedFileError

router = APIRouter(prefix="/api/courses", tags=["courses"])


def _to_lesson_out(video: Video, order: int) -> LessonOut:
    return LessonOut(
        id=video.id,
        title=video.title,
        description=video.description,
        video_url=f"/media/{video.hls_path}" if video.hls_path else "",
        duration_seconds=video.duration_seconds or 0,
        order=order,
    )


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


@router.post("", response_model=CourseOut)
async def create_course(
    title: str = Form(...),
    description: str = Form(""),
    instructor_id: str = Form(...),
    instructor_name: str = Form(...),
    category_id: str = Form(...),
    thumbnail_url: str = Form(...),
    db: AsyncSession = Depends(get_db),
) -> CourseOut:
    try:
        course = await course_service.create_course(
            db,
            title=title,
            description=description,
            instructor=Instructor(id=instructor_id, name=instructor_name),
            category_id=category_id,
            thumbnail_url=thumbnail_url,
        )
    except InvalidReferenceError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    return CourseOut.model_validate(course)


@router.get("", response_model=CourseListOut)
async def get_courses(
    category_id: str | None = None,
    search: str | None = None,
    db: AsyncSession = Depends(get_db),
) -> CourseListOut:
    courses = await course_service.list_courses(db, category_id=category_id, search=search)
    return CourseListOut(
        items=[CourseOut.model_validate(course) for course in courses],
        total=len(courses),
    )


@router.get("/popular", response_model=CourseListOut)
async def get_popular_courses(db: AsyncSession = Depends(get_db)) -> CourseListOut:
    courses = await course_service.list_popular_courses(db)
    return CourseListOut(
        items=[CourseOut.model_validate(course) for course in courses],
        total=len(courses),
    )


@router.get("/{course_id}", response_model=CourseDetailOut)
async def get_course(course_id: str, db: AsyncSession = Depends(get_db)) -> CourseDetailOut:
    course = await course_service.get_course(db, course_id)
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = await video_service.list_videos_by_course(db, course_id)
    lessons = [_to_lesson_out(video, order) for order, video in enumerate(videos)]
    total_duration_seconds = sum(lesson.duration_seconds for lesson in lessons)

    course_out = CourseOut.model_validate(course)
    return CourseDetailOut(
        **course_out.model_dump(),
        lessons=lessons,
        total_duration_seconds=total_duration_seconds,
    )


UploadFile = Annotated[UF, WithJsonSchema({"type": "string", "format": "binary"})]


@router.post("/{course_id}/videos", response_model=list[VideoOut])
async def upload_course_videos(
    course_id: str,
    background_tasks: BackgroundTasks,
    files: list[UploadFile] = File(...),
    db: AsyncSession = Depends(get_db),
) -> list[VideoOut]:
    if await course_service.get_course(db, course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    created: list[Video] = []
    for file in files:
        title = Path(file.filename or "untitled").stem
        try:
            video, original_path = await video_service.create_video(
                db,
                title=title,
                description="",
                course_id=course_id,
                file=file,
            )
        except UnsupportedFileError as exc:
            raise HTTPException(status_code=400, detail=f"{file.filename}: {exc}") from exc

        background_tasks.add_task(process_video, video.id, original_path)
        created.append(video)

    return [_to_video_out(video) for video in created]


@router.get("/{course_id}/videos", response_model=VideoListOut)
async def get_course_videos(course_id: str, db: AsyncSession = Depends(get_db)) -> VideoListOut:
    if await course_service.get_course(db, course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = await video_service.list_videos_by_course(db, course_id)
    return VideoListOut(items=[_to_video_out(video) for video in videos], total=len(videos))
