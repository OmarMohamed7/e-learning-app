# Local HLS Video Server

A small **FastAPI-based local video server** for the Mentor Stream e-learning Flutter project.

The purpose of this project is to learn and demonstrate the complete HLS video pipeline locally:

```text
MP4 Video
    ↓
FastAPI Upload API
    ↓
Save Original Video
    ↓
FFmpeg Transcoding
    ↓
HLS Generation
    ↓
.m3u8 + video segments
    ↓
FastAPI Static File Serving
    ↓
Flutter HLS Player
```

The server provides APIs for uploading videos, assigning them to predefined categories, converting them to HLS, and retrieving categories/videos.

Swagger/OpenAPI documentation is available automatically through FastAPI.

---

# 1. Goals

The server should support:

* Uploading video files.
* Assigning each video to one of four categories.
* Persisting video metadata.
* Converting uploaded MP4 videos to HLS using FFmpeg.
* Generating multiple HLS quality levels.
* Generating a master `.m3u8` playlist.
* Serving HLS playlists and segments over HTTP.
* Getting all available categories.
* Getting videos by category.
* Getting a single video.
* Providing Swagger/OpenAPI documentation.
* Returning a playback URL that can be consumed by Flutter.

This is intentionally a **local development server**.

It is not intended to be production-ready video infrastructure.

---

# 2. Categories

The application will initially support exactly four categories:

```text
Business
Finance
Programming
UI_UX
```

Use an enum rather than accepting arbitrary category strings.

Example:

```python
class VideoCategory(str, Enum):
    BUSINESS = "business"
    FINANCE = "finance"
    PROGRAMMING = "programming"
    UI_UX = "UI_UX"
```

This prevents invalid categories from being stored.

---

# 3. Project Structure

Recommended structure:

```text
local-hls-server/
│
├── app/
│   ├── main.py
│   │
│   ├── api/
│   │   ├── categories.py
│   │   └── videos.py
│   │
│   ├── models/
│   │   └── video.py
│   │
│   ├── schemas/
│   │   ├── category.py
│   │   └── video.py
│   │
│   ├── services/
│   │   ├── video_service.py
│   │   └── hls_service.py
│   │
│   └── core/
│       └── config.py
│
├── storage/
│   ├── originals/
│   │
│   └── hls/
│       └── <video_id>/
│           ├── master.m3u8
│           ├── 360p/
│           │   ├── playlist.m3u8
│           │   ├── segment_000.ts
│           │   └── ...
│           │
│           └── 720p/
│               ├── playlist.m3u8
│               ├── segment_000.ts
│               └── ...
│
├── requirements.txt
├── .gitignore
└── README.md
```

---

# 4. Technology Stack

## Backend

* Python
* FastAPI
* Uvicorn
* Pydantic
* FFmpeg

## Storage

For the first version:

```text
Local filesystem
```

No database is required initially.

Video metadata can be stored in a simple JSON file or SQLite.

A recommended progression is:

```text
Version 1 → JSON
Version 2 → SQLite
Version 3 → PostgreSQL
Version 4 → Cloud storage + Mux
```

---

# 5. FFmpeg Requirement

FFmpeg must be installed on the development machine.

Verify:

```bash
ffmpeg -version
```

If FFmpeg is not installed, install it using the appropriate package manager for your operating system.

The application should not assume FFmpeg is available without checking.

At startup, optionally validate that FFmpeg can be executed.

---

# 6. HLS Output

Each uploaded video should be converted into HLS.

For example:

```text
originals/
└── lesson.mp4
```

becomes:

```text
hls/
└── 7f3c9c2e/
    ├── master.m3u8
    │
    ├── 360p/
    │   ├── playlist.m3u8
    │   ├── segment_000.ts
    │   ├── segment_001.ts
    │   └── ...
    │
    └── 720p/
        ├── playlist.m3u8
        ├── segment_000.ts
        ├── segment_001.ts
        └── ...
```

The master playlist references the available quality variants.

Conceptually:

```text
master.m3u8
    │
    ├── 360p/playlist.m3u8
    │
    └── 720p/playlist.m3u8
```

---

# 7. Video Processing

The server should not transcode the video on every playback request.

The processing flow is:

```text
Upload
  ↓
Save original MP4
  ↓
Generate video ID
  ↓
FFmpeg
  ↓
Generate HLS
  ↓
Mark video as READY
```

Only after the video is ready should the API expose the playback URL.

---

# 8. Video Status

Each video should have a processing status.

```python
class VideoStatus(str, Enum):
    PROCESSING = "processing"
    READY = "ready"
    FAILED = "failed"
```

Example:

```json
{
  "id": "7f3c9c2e",
  "title": "Introduction to Flutter",
  "category": "programming",
  "status": "ready",
  "hls_url": "/media/7f3c9c2e/master.m3u8"
}
```

This is important because HLS generation can take time.

---

# 9. Upload API

## POST `/api/videos`

Upload a video and assign it to a category.

The request should use `multipart/form-data`.

Fields:

```text
file
title
description
category
```

Example:

```text
POST /api/videos
Content-Type: multipart/form-data
```

Request:

```text
file: flutter_architecture.mp4
title: Flutter Architecture
description: Introduction to clean architecture
category: programming
```

The server should:

1. Validate the category.
2. Validate the file type.
3. Generate a unique video ID.
4. Save the original file.
5. Start HLS conversion.
6. Store metadata.
7. Return the video information.

Example response:

```json
{
  "id": "7f3c9c2e",
  "title": "Flutter Architecture",
  "description": "Introduction to clean architecture",
  "category": "programming",
  "status": "processing"
}
```

---

# 10. Video Validation

The first version should support:

```text
.mp4
```

Optionally allow:

```text
.mov
.mkv
```

but normalize the output to HLS.

The server should reject unsupported file extensions.

Also validate the uploaded content type.

Do not trust the filename alone.

---

# 11. Category APIs

## GET `/api/categories`

Returns all available categories.

Example:

```json
[
  {
    "id": "business",
    "name": "Business"
  },
  {
    "id": "finance",
    "name": "Finance"
  },
  {
    "id": "programming",
    "name": "Programming"
  },
  {
    "id": "UI_UX",
    "name": "UI_UX"
  }
]
```

---

# 12. Video APIs

## GET `/api/videos`

Returns all videos.

Optional filtering:

```text
GET /api/videos?category=programming
```

Example response:

```json
{
  "items": [
    {
      "id": "7f3c9c2e",
      "title": "Flutter Architecture",
      "category": "programming",
      "status": "ready",
      "hls_url": "/media/7f3c9c2e/master.m3u8"
    }
  ],
  "total": 1
}
```

---

## GET `/api/videos/{video_id}`

Returns a single video.

Example:

```text
GET /api/videos/7f3c9c2e
```

Response:

```json
{
  "id": "7f3c9c2e",
  "title": "Flutter Architecture",
  "description": "Introduction to clean architecture",
  "category": "programming",
  "status": "ready",
  "hls_url": "/media/7f3c9c2e/master.m3u8"
}
```

---

# 13. HLS Media API

HLS files should be exposed through a static media route.

Example:

```text
GET /media/{video_id}/master.m3u8
```

and:

```text
GET /media/{video_id}/360p/playlist.m3u8
GET /media/{video_id}/360p/segment_000.ts
```

The master playlist should be the URL returned to Flutter.

Example:

```text
http://localhost:8000/media/7f3c9c2e/master.m3u8
```

---

# 14. FastAPI Static Files

FastAPI can expose the generated HLS directory using `StaticFiles`.

Conceptually:

```python
app.mount(
    "/media",
    StaticFiles(directory="storage/hls"),
    name="media",
)
```

Therefore:

```text
storage/hls/7f3c9c2e/master.m3u8
```

becomes:

```text
/media/7f3c9c2e/master.m3u8
```

This is intentionally simple.

A production system would normally use object storage/CDN rather than FastAPI to serve video segments.

---

# 15. HLS Quality Levels

The first implementation should generate at least two variants:

```text
360p
720p
```

Example target bitrates:

```text
360p → ~600 Kbps
720p → ~2 Mbps
```

The master playlist should contain both variants.

Conceptually:

```text
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=600000,RESOLUTION=640x360
360p/playlist.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720
720p/playlist.m3u8
```

This allows the Flutter HLS player to select an appropriate rendition.

---

# 16. Segment Duration

Use a short segment duration such as:

```text
6 seconds
```

Example:

```text
-hls_time 6
```

For this project, HLS should use VOD mode:

```text
EXT-X-PLAYLIST-TYPE:VOD
```

because the application is an e-learning platform with pre-recorded lessons.

---

# 17. Upload Processing Strategy

### Initial implementation

Use a synchronous/simple processing flow for learning purposes:

```text
POST /videos
     ↓
Save file
     ↓
FFmpeg
     ↓
Return READY
```

However, this means the HTTP request remains open while FFmpeg runs.

### Improved implementation

Use a background task:

```text
POST /videos
     ↓
Save file
     ↓
Create PROCESSING record
     ↓
Background FFmpeg job
     ↓
READY / FAILED
```

This is the recommended implementation for the project.

Later, this can evolve into:

```text
FastAPI
   ↓
Task Queue
   ↓
FFmpeg Worker
```

but Celery/Redis are not required for the first version.

---

# 18. Suggested Data Model

For the first version:

```python
class Video:
    id: str
    title: str
    description: str
    category: VideoCategory
    original_filename: str
    status: VideoStatus
    hls_path: str | None
    created_at: datetime
```

Example:

```json
{
  "id": "7f3c9c2e",
  "title": "Introduction to Finance",
  "description": "Understanding basic financial concepts",
  "category": "finance",
  "original_filename": "finance_intro.mp4",
  "status": "ready",
  "hls_path": "7f3c9c2e/master.m3u8"
}
```

---

# 19. API Overview

The initial API should contain:

| Method | Endpoint                  | Purpose                |
| ------ | ------------------------- | ---------------------- |
| GET    | `/api/categories`         | Get all categories     |
| GET    | `/api/videos`             | Get all videos         |
| GET    | `/api/videos/{id}`        | Get video details      |
| POST   | `/api/videos`             | Upload video           |
| GET    | `/media/{id}/master.m3u8` | HLS master playlist    |
| GET    | `/media/{id}/...`         | HLS playlists/segments |

---

# 20. Swagger

FastAPI automatically provides:

```text
/swagger
```

and:

```text
/redoc
```

The primary development interface should be Swagger UI.

After starting the server:

```text
http://localhost:8000/docs
```

From Swagger, it should be possible to:

* View categories.
* Upload videos.
* Select a category.
* Retrieve videos.
* Retrieve a specific video.
* Test API responses.

---

# 21. Example Flutter Flow

Flutter should not know anything about FFmpeg.

The Flutter application should simply consume the API:

```text
GET /api/categories
        ↓
Category list
        ↓
GET /api/videos?category=programming
        ↓
Video list
        ↓
GET /api/videos/{id}
        ↓
hls_url
        ↓
HLS Video Player
```

Example:

```json
{
  "id": "7f3c9c2e",
  "title": "Flutter Architecture",
  "category": "programming",
  "status": "ready",
  "hls_url": "http://localhost:8000/media/7f3c9c2e/master.m3u8"
}
```

The Flutter player only needs:

```text
hls_url
```

---

# 22. Development Milestones

## Milestone 1 — FastAPI Setup

Deliver:

* FastAPI project.
* Uvicorn.
* Health endpoint.
* Swagger.
* Project structure.

Endpoint:

```text
GET /health
```

---

## Milestone 2 — Categories

Deliver:

* Category enum.
* Category schema.
* Category endpoint.

Endpoint:

```text
GET /api/categories
```

---

## Milestone 3 — Video Upload

Deliver:

* Multipart upload.
* File validation.
* Category validation.
* Local file storage.
* Video metadata.

Endpoint:

```text
POST /api/videos
```

---

## Milestone 4 — FFmpeg Integration

Deliver:

* FFmpeg service.
* MP4 → HLS conversion.
* 360p generation.
* 720p generation.
* Master playlist generation.

---

## Milestone 5 — HLS Serving

Deliver:

```text
/media/{video_id}/master.m3u8
```

and all required playlists/segments.

Verify the stream using a desktop HLS-compatible player before connecting Flutter.

---

## Milestone 6 — Video APIs

Deliver:

```text
GET /api/videos
GET /api/videos/{id}
GET /api/videos?category=programming
```

---

## Milestone 7 — Flutter Integration

Flutter should:

1. Load categories.
2. Display videos.
3. Open video details.
4. Request the HLS URL.
5. Play the HLS stream.
6. Display loading state.
7. Display playback errors.

---

# 23. Testing

The server should be tested independently from Flutter.

First verify:

```text
Upload
   ↓
FFmpeg
   ↓
HLS generated
   ↓
master.m3u8 accessible
```

Then test:

```text
master.m3u8
     ↓
360p playlist
     ↓
segments
```

and:

```text
master.m3u8
     ↓
720p playlist
     ↓
segments
```

Only after this works should Flutter integration begin.

---

# 24. Future Production Architecture

The local implementation intentionally simulates a production video pipeline.

Current:

```text
Flutter
   ↓
FastAPI
   ↓
Local Filesystem
   ↓
FFmpeg
   ↓
HLS
```

A production architecture could become:

```text
Flutter
   ↓
Backend API
   ↓
Database
   ↓
Video Provider / Mux
   ↓
Transcoding
   ↓
CDN
   ↓
HLS
```

The Flutter application should ideally not care whether the HLS URL comes from the local server or Mux.

For example:

```text
VideoRepository
      ↓
Video
      ↓
hlsUrl
      ↓
VideoPlayer
```

This keeps the video infrastructure behind the repository/data layer.

---

# 25. Future Improvements

After the basic server works, possible improvements include:

* SQLite/PostgreSQL.
* Authentication.
* Video deletion.
* Video processing status polling.
* Background processing.
* Thumbnail generation with FFmpeg.
* Video duration extraction.
* Automatic metadata extraction.
* Pagination.
* Search.
* Category filtering.
* Signed playback URLs.
* Object storage.
* CDN.
* Mux integration.
* Docker.
* Automated tests.
* CI/CD.

Do not implement these initially.

The primary objective is:

```text
Upload MP4
    ↓
FFmpeg
    ↓
HLS
    ↓
FastAPI
    ↓
Flutter
```

---

# 26. Definition of Done

The first version is complete when:

* [ ] FastAPI starts successfully.
* [ ] Swagger UI is available.
* [ ] Four predefined categories exist.
* [ ] Categories can be retrieved using an API.
* [ ] A video can be uploaded through Swagger.
* [ ] The video can be assigned to a category.
* [ ] The original MP4 is stored locally.
* [ ] FFmpeg converts the MP4 to HLS.
* [ ] 360p HLS is generated.
* [ ] 720p HLS is generated.
* [ ] A master `.m3u8` playlist is generated.
* [ ] HLS segments are accessible through HTTP.
* [ ] Videos can be retrieved through the API.
* [ ] Videos can be filtered by category.
* [ ] A single video can be retrieved.
* [ ] The API returns an HLS playback URL.
* [ ] The HLS URL can be played by an HLS-compatible player.
* [ ] Flutter can retrieve the video and play it.
* [ ] The Flutter application does not need to know anything about FFmpeg.

---

# 27. Final Architecture

The completed MVP should look like:

```text
                         ┌─────────────────┐
                         │     Flutter     │
                         │                 │
                         │ Courses         │
                         │ Categories      │
                         │ Video Player    │
                         └────────┬────────┘
                                  │
                              REST API
                                  │
                                  ▼
                         ┌─────────────────┐
                         │     FastAPI     │
                         │                 │
                         │ Categories API │
                         │ Videos API     │
                         │ Upload API     │
                         │ HLS Serving    │
                         └────────┬────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
             Local Metadata                Local Storage
                    │                           │
                    │                    ┌──────┴──────┐
                    │                    │             │
                    │                  MP4           HLS
                    │                                  │
                    │                                  │
                    │                              .m3u8
                    │                                  │
                    │                              .ts files
                    │
                    └───────────────────────────────┐
                                                    │
                                                    ▼
                                               FFmpeg
```

The key learning objective is not simply **"play a video from a URL."**

It is understanding the complete flow:

```text
                    HLS PIPELINE

Original Video
      │
      ▼
   FFmpeg
      │
      ├──────────────┐
      ▼              ▼
   360p             720p
      │              │
      ▼              ▼
playlist.m3u8    playlist.m3u8
      │              │
      └──────┬───────┘
             ▼
        master.m3u8
             │
             ▼
         FastAPI
             │
             ▼
          Flutter
             │
             ▼
       HLS Player
```

This gives you the foundation for the next stage of the Mentor Stream project: **building the Flutter video-learning experience on top of a real HLS pipeline, then later swapping the local video infrastructure for Mux.**
