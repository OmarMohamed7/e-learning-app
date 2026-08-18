# E-Learning (Flutter + FastApi)

Monorepo for the e-learning app: a Flutter mobile client backed by a
local FastAPI video server that handles HLS transcoding and streaming.

```
.
├── backend/   FastAPI HLS video server (Python, PostgreSQL, FFmpeg)
└── mobile/    Flutter client app (iOS/Android)
```

## Overview

- **backend/** — A local FastAPI server that accepts uploaded MP4 videos, transcodes
  them to HLS with FFmpeg, and serves categories, videos, and HLS playlists/segments
  to the mobile app. See [`backend/README.md`](backend/README.md) for the full spec.
- **mobile/** — The Flutter app that browses courses/categories and plays videos via
  the backend's REST API and HLS streams. There's no auth — browsing is anonymous,
  and per-lesson watch progress is stored locally on-device (Isar).

### Video quality control

HLS quality variants (e.g. `360p`/`720p`, their resolutions, and target bitrates)
are **manually configured on the backend, not auto-detected from the uploaded
video.** Each variant is a row in the `hls_variants` Postgres table, seeded via an
Alembic migration; every upload gets transcoded into exactly those configured
variants. To add, remove, or retune a quality level, edit that table (a new
migration) — not the transcoding code itself. See
[`backend/README.md` §15](backend/README.md#15-hls-quality-levels) for details.

## Architecture

For how the two projects fit together (request flow, the HLS pipeline, and the
mobile app's layering) see [`ARCHITECTURE.md`](ARCHITECTURE.md).

## Prerequisites

- Python 3.13+ and [`uv`](https://docs.astral.sh/uv/)
- PostgreSQL 
- FFmpeg (`ffmpeg -version` to check)
- Flutter SDK (Dart ^3.11.5) and a configured iOS/Android toolchain

## Running the backend

```bash
cd backend
uv sync

createdb elearning_stream            # create the local Postgres database
cp .env.example .env              # adjust DATABASE_URL if needed
uv run alembic upgrade head       # apply migrations

uv run uvicorn app.main:app --reload
```

The API docs are then available at `http://localhost:8000/docs`.

## Running the mobile app

```bash
cd mobile
flutter pub get

# Generates freezed/json_serializable/retrofit/isar code
dart run build_runner build

flutter run
```

<table border="0">
  <tr>
    <td><img src="image-4.png" width="300" alt="Image 1"></td>
    <td><img src="image-5.png" width="300" alt="Image 2"></td>
  </tr>
  <tr>
    <td><img src="image-2.png" width="300" alt="Image 3"></td>
    <td><img src="image-6.png" width="300" alt="Image 4"></td>
  </tr>
</table>
