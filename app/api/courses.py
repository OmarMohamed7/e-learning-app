from pathlib import Path

from fastapi import APIRouter, BackgroundTasks, File, Form, HTTPException, UploadFile as UF
from pydantic import WithJsonSchema

from app.models.instructor import Instructor
from app.models.video import Video, VideoCategory
from app.schemas.course import CourseDetailOut, CourseListOut, CourseOut, LessonOut
from app.schemas.video import VideoListOut, VideoOut
from app.services import course_service, video_service
from app.services.hls_service import process_video
from app.services.video_service import UnsupportedFileError
from typing import Annotated


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
def create_course(
    title: str = Form(...),
    description: str = Form(""),
    instructor_id: str = Form(...),
    instructor_name: str = Form(...),
    category: VideoCategory = Form(...),
    thumbnail_url: str = Form(...),
) -> CourseOut:
    course = course_service.create_course(
        title=title,
        description=description,
        instructor=Instructor(id=instructor_id, name=instructor_name),
        category=category,
        thumbnail_url=thumbnail_url,
    )
    return CourseOut(**course.model_dump())


@router.get("", response_model=CourseListOut)
def get_courses(category: VideoCategory | None = None, search: str | None = None) -> CourseListOut:
    courses = course_service.list_courses(category=category, search=search)
    return CourseListOut(items=[CourseOut(**course.model_dump()) for course in courses], total=len(courses))


@router.get("/popular", response_model=CourseListOut)
def get_popular_courses() -> CourseListOut:
    courses = course_service.list_popular_courses()
    return CourseListOut(items=[CourseOut(**course.model_dump()) for course in courses], total=len(courses))


@router.get("/{course_id}", response_model=CourseDetailOut)
def get_course(course_id: str) -> CourseDetailOut:
    course = course_service.get_course(course_id)
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = video_service.list_videos_by_course(course_id)
    lessons = [_to_lesson_out(video, order) for order, video in enumerate(videos)]
    total_duration_seconds = sum(lesson.duration_seconds for lesson in lessons)

    return CourseDetailOut(
        **course.model_dump(),
        lessons=lessons,
        total_duration_seconds=total_duration_seconds,
    )

UploadFile = Annotated[UF, WithJsonSchema({"type": "string", "format": "binary"})]

@router.post("/{course_id}/videos", response_model=list[VideoOut])
async def upload_course_videos(
    course_id: str,
    background_tasks: BackgroundTasks,
   files: list[UploadFile] = File(...)
) -> list[VideoOut]:
    if course_service.get_course(course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    created: list[Video] = []
    for file in files:
        title = Path(file.filename or "untitled").stem
        try:
            video, original_path = video_service.create_video(
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
def get_course_videos(course_id: str) -> VideoListOut:
    if course_service.get_course(course_id) is None:
        raise HTTPException(status_code=404, detail="Course not found")

    videos = video_service.list_videos_by_course(course_id)
    return VideoListOut(items=[_to_video_out(video) for video in videos], total=len(videos))
