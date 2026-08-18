# Architecture

E-Learning (Mentor Stream) has two halves that talk to each other over plain HTTP,
plus Firebase for auth/account data. There is no shared code between them — the
contract between the two is just the backend's REST API and the shape of an HLS
stream.

```
┌────────────────────────┐        REST (JSON)        ┌──────────────────────────┐
│   mobile/ (Flutter)     │ ─────────────────────────▶│   backend/ (FastAPI)     │
│   - browse categories   │◀───────────────────────── │   - categories/videos    │
│   - browse courses      │        HLS (.m3u8 +        │     APIs                 │
│   - play video lessons  │◀─────  .ts segments) ───── │   - HLS transcoding      │
└──────────┬──────────────┘                            └──────────┬───────────────┘
           │                                                       │
           │ Firebase Auth / Firestore                             │ SQLAlchemy (async)
           ▼                                                       ▼
   ┌───────────────┐                                       ┌───────────────┐
   │   Firebase     │                                       │  PostgreSQL   │
   │ (account data) │                                       │ (courses,     │
   └───────────────┘                                        │  videos, HLS  │
                                                              │  variants)    │
                                                              └───────────────┘
                                                                     │
                                                                     ▼
                                                              ┌───────────────┐
                                                              │    FFmpeg     │
                                                              │ (transcoding) │
                                                              └───────────────┘
```

Firebase and the backend are independent: Firebase owns identity/account state,
the FastAPI service owns course/video content and never sees a user's Firebase
identity today.

---

## backend/ — FastAPI HLS video server

Local development server that ingests MP4 uploads, transcodes them to HLS with
FFmpeg, and serves categories/videos/playlists to the mobile app.

```
app/
├── api/         # FastAPI routers (categories, courses, videos)
├── core/        # Settings (pydantic-settings) and the async DB engine/session
├── models/      # SQLAlchemy ORM models (course, category, instructor, video, hls_variant)
├── schemas/     # Pydantic request/response schemas
└── services/    # Business logic (course_service, video_service, hls_service)
```

- **Web framework**: FastAPI, served by Uvicorn with `--reload` for local dev.
- **Persistence**: PostgreSQL via SQLAlchemy's async engine (`asyncpg`), schema
  managed with Alembic migrations — no ORM `create_all`, every schema change is
  a migration.
- **Video pipeline**: an uploaded MP4 is saved to `storage/originals/`, handed to
  `hls_service`, which shells out to FFmpeg to produce multiple renditions (the
  quality ladder lives in the `hls_variant` DB table, not hardcoded) plus a
  master `.m3u8`, written to `storage/hls/<video_id>/`.
  See `1. Goals` → `17. Upload Processing Strategy` in
  [`backend/README.md`](backend/README.md) for the request-lifecycle detail.
- **Serving**: HLS playlists/segments are served as static files directly by
  FastAPI; the API returns the playback URL the mobile app's video player hits.
- **API docs**: Swagger/OpenAPI is auto-generated at `/docs`.

This is intentionally a local dev server, not production video infrastructure.

## mobile/ — Flutter client

A feature-first Flutter app using a light clean-architecture split
(`data` / `domain` / `presentation`) inside each feature.

```
lib/
├── app/                # App shell: go_router routes, bottom-nav shell, theming
├── core/                # Cross-cutting: Dio+Retrofit client, Isar local storage,
│                        # Firebase bootstrap, logging, shared errors/widgets
└── features/
    ├── courses/         # Categories, home feed, course details, search
    ├── categories/
    ├── progress/        # Lesson/course watch progress
    ├── video_player/    # HLS playback screen
    └── account/
```

Per feature, the dependency direction is `presentation → domain → data`:

- **domain/** — plain entities and a repository *interface*
  (e.g. `courses/domain/repositories/i_courses_repo.dart`); no Flutter or
  networking imports here.
- **data/** — the repository implementation, `retrofit`-generated API clients
  (`course_api.dart`) hitting the backend, and `freezed`/`json_serializable`
  models that (de)serialize its JSON responses.
- **presentation/** — pages/widgets plus Riverpod providers that expose
  repository data to the UI as state.

Other things worth knowing:

- **State management**: Riverpod (`flutter_riverpod`) throughout.
- **Routing**: `go_router`, with a `StatefulShellRoute` for the bottom-tab shell
  (home / my courses / account) and pushed routes for search, category, course
  details, and the video player (`lib/app/router/app_router.dart`).
- **Networking**: `dio` + `retrofit` clients in `core/network/`, generated per
  feature (e.g. `course_api.dart` + `course_api.g.dart`).
- **Local storage**: `isar_community` (`core/storage/isar_provider.dart`) for
  on-device caching/persistence (e.g. watch progress).
- **Firebase**: `firebase_core`/`firebase_auth`/`cloud_firestore`, bootstrapped
  in `core/firebase/firebase_bootstrap.dart` via a generated
  `firebase_options.dart` (run `flutterfire configure` locally — this file is
  gitignored and not committed).
- **Playback**: `video_player` + `chewie` consume the HLS `.m3u8` URL returned
  by the backend.
- **Code generation**: `freezed`, `json_serializable`, `retrofit_generator`, and
  `isar_community_generator` all run through `build_runner` — see the root
  [`README.md`](README.md) for the command.
