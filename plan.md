# MentorStream

A production-oriented Flutter video learning platform built as a technical demonstration of modern e-learning architecture, HLS video streaming, adaptive bitrate playback, learning progress tracking, and scalable Flutter application design.

The project is inspired by the engineering challenges of modern video-based learning platforms such as almentor.

> **Goal:** Demonstrate how I would design and implement the client-side architecture of a production e-learning platform, with particular focus on video streaming and learning experience.

---

## 1. Project Goals

The project focuses on the following engineering areas:

* Flutter application architecture
* Clean Architecture
* Riverpod state management
* HLS video streaming
* Adaptive bitrate playback
* Video player state management
* Course and lesson navigation
* Learning progress tracking
* Resume playback
* Lesson completion
* Offline-friendly architecture
* Error handling and retry
* Arabic/English localization
* RTL support
* Testing
* Production-oriented code organization

The project intentionally does **not** attempt to implement a complete commercial e-learning platform.

Instead, it focuses on building a small but realistic learning experience.

---

# 2. Core User Journey

The main user journey is:

```text
Home
  ↓
Course
  ↓
Course Details
  ↓
Select Lesson
  ↓
HLS Video Player
  ↓
Watch Lesson
  ↓
Progress Saved
  ↓
Lesson Completed
  ↓
Next Lesson
  ↓
Course Progress Updated
```

The application should make this flow feel like a real learning platform rather than a video-player demo.

---

# 3. Main Features

## Course Discovery

* Featured courses
* Course categories
* Course cards
* Continue Learning section
* Course progress

## Course Details

* Course title
* Description
* Instructor
* Duration
* Number of lessons
* Lesson list
* Completed lessons
* Current lesson
* Overall course progress

## Video Player

* HLS streaming
* Adaptive bitrate
* Play / pause
* Seek
* Skip forward/backward
* Playback speed
* Fullscreen
* Buffering state
* Loading state
* Error state
* Retry
* Quality selection
* Subtitle support if available

## Learning Progress

* Save playback position
* Resume playback
* Lesson completion
* Course completion percentage
* Continue Learning
* Progress synchronization abstraction

## Localization

* English
* Arabic
* RTL support

---

# 4. Architecture

The application will follow Clean Architecture with feature-based organization.

```text
lib/

├── app/
│   ├── router/
│   ├── theme/
│   └── localization/
│
├── core/
│   ├── network/
│   ├── storage/
│   ├── errors/
│   ├── logging/
│   └── utils/
│
└── features/
    │
    ├── courses/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── video_player/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── progress/
        ├── data/
        ├── domain/
        └── presentation/
```

The dependency direction should be:

```text
Presentation
      ↓
Domain
      ↓
Data
```

The domain layer should not depend on Flutter or specific infrastructure implementations.

---

# 5. State Management

Riverpod will be used for:

* dependency injection
* asynchronous state
* feature state
* video-player state
* repository providers
* lifecycle management

Example:

```text
UI
 ↓
Riverpod Provider
 ↓
Use Case
 ↓
Repository
 ↓
Data Source
```

The goal is to keep business logic outside widgets.

---

# 6. Video Architecture

Video streaming is the primary technical focus of the project.

```text
Original Video
      │
      ▼
Video Processing
      │
      ├── 1080p
      ├── 720p
      ├── 480p
      └── 360p
      │
      ▼
HLS Playlists
      │
      ▼
master.m3u8
      │
      ▼
Flutter Video Player
      │
      ▼
Adaptive Bitrate Streaming
```

The application consumes an HLS master playlist.

Example:

```text
master.m3u8
```

The master playlist references multiple quality variants.

The player can then select an appropriate stream based on network conditions and device capabilities.

---

# 7. HLS Demonstration

The project should demonstrate a real HLS workflow.

Example structure:

```text
lesson/
├── master.m3u8
│
├── 1080p/
│   ├── playlist.m3u8
│   └── segments/
│
├── 720p/
│   ├── playlist.m3u8
│   └── segments/
│
├── 480p/
│   ├── playlist.m3u8
│   └── segments/
│
└── 360p/
    ├── playlist.m3u8
    └── segments/
```

FFmpeg can be used to generate the HLS renditions from a source video.

The project does not need to build a complete production transcoding infrastructure.

The goal is to demonstrate understanding of the pipeline.

---

# 8. Backend Strategy

A separate backend will intentionally NOT be required for the initial project.

The application will use a repository abstraction.

```text
Presentation
      ↓
Domain
      ↓
Repository Interface
      ↓
Mock Repository
      ↓
Local JSON / Local Storage
```

Example:

```dart
abstract class CourseRepository {
  Future<List<Course>> getCourses();

  Future<Course> getCourse(String id);
}
```

The initial implementation:

```dart
class MockCourseRepository implements CourseRepository {
  // Load data from local JSON
}
```

This allows the implementation to later be replaced with:

```text
REST API
GraphQL API
Firebase
Supabase
FastAPI
```

without changing the presentation layer.

---

# 9. Data Sources

Initial course data:

```text
assets/
└── mock/
    ├── courses.json
    ├── lessons.json
    └── instructors.json
```

Progress can initially be stored locally.

For example:

```text
SharedPreferences / Hive / Isar
```

The repository abstraction should make the storage implementation replaceable.

---

# 10. HLS Hosting Alternatives

There are several possible approaches.

### Option A — Public HLS streams

Use an existing publicly accessible HLS stream during development.

Advantages:

* zero infrastructure
* real HLS
* fast development
* good for demonstrating the player

Disadvantage:

* stream availability is not controlled by the project

---

### Option B — Local HLS server

Generate HLS files using FFmpeg and serve them locally.

Example:

```text
FFmpeg
  ↓
HLS files
  ↓
Local HTTP server
  ↓
Flutter
```

This is useful for understanding the complete pipeline.

---

### Option C — Object Storage/CDN

Upload generated HLS files to an object-storage provider and expose them through HTTP/CDN.

Conceptually:

```text
FFmpeg
  ↓
HLS
  ↓
Object Storage
  ↓
CDN
  ↓
Flutter
```

This is closer to a production architecture.

---

# 11. Progress Architecture

Playback progress should be treated as a separate domain concept.

```text
Video Player
     │
     │ periodic updates
     ▼
Progress Manager
     │
     ▼
Progress Repository
     │
     ▼
Local Storage
```

Example:

```json
{
  "lessonId": "lesson_01",
  "position": 754,
  "duration": 1840,
  "completed": false
}
```

When reopening a lesson:

```text
Lesson
  ↓
Load Progress
  ↓
position = 754
  ↓
Seek player
  ↓
Continue from 12:34
```

Progress should not be persisted on every playback tick.

A reasonable initial strategy is to persist periodically, for example every 10–15 seconds, and when the player is paused/backgrounded/disposed.

---

# 12. Video Player State

The player should explicitly model its state.

```text
Idle
 ↓
Initializing
 ↓
Ready
 ↓
Playing
 ↓
Buffering
 ↓
Playing

Ready
 ↓
Paused

Any state
 ↓
Error
 ↓
Retry
```

Possible state model:

```dart
sealed class VideoPlayerState {}

class VideoIdle extends VideoPlayerState {}

class VideoInitializing extends VideoPlayerState {}

class VideoReady extends VideoPlayerState {}

class VideoPlaying extends VideoPlayerState {}

class VideoPaused extends VideoPlayerState {}

class VideoBuffering extends VideoPlayerState {}

class VideoError extends VideoPlayerState {
  final String message;
}
```

This avoids scattering unrelated boolean flags throughout the UI.

---

# 13. Seven-Day Implementation Plan

## Day 1 — Architecture & Project Foundation

### Objectives

Create the Flutter foundation and establish the architecture.

### Tasks

* [ ] Create Flutter project
* [ ] Configure flavors/environment if needed
* [ ] Configure linting
* [ ] Configure folder structure
* [ ] Add Riverpod
* [ ] Add routing
* [ ] Add localization
* [ ] Add theme
* [ ] Create core error handling
* [ ] Create logging abstraction
* [ ] Create domain models

### Deliverables

```text
Flutter project
+
Clean Architecture
+
Riverpod
+
Routing
+
Localization
+
Initial domain models
```

---

# Day 2 — Course & Learning Experience

### Objectives

Build the main e-learning experience.

### Tasks

* [ ] Home screen
* [ ] Featured courses
* [ ] Continue Learning
* [ ] Course details
* [ ] Lesson list
* [ ] Course progress UI
* [ ] Course repository
* [ ] Local JSON data source
* [ ] Loading states
* [ ] Error states

### Deliverables

Complete navigation:

```text
Home
 ↓
Course Details
 ↓
Lesson List
```

---

# Day 3 — HLS Pipeline

### Objectives

Understand and implement the video-processing pipeline.

### Tasks

* [ ] Select sample video
* [ ] Install/configure FFmpeg
* [ ] Generate multiple resolutions
* [ ] Generate HLS playlists
* [ ] Generate master.m3u8
* [ ] Test HLS stream independently
* [ ] Host HLS locally or remotely
* [ ] Document HLS architecture

### Deliverables

```text
master.m3u8
 ├── 1080p
 ├── 720p
 ├── 480p
 └── 360p
```

and a working HLS URL.

---

# Day 4 — Production-Style Video Player

### Objectives

Build the main technical component.

### Tasks

* [ ] Video player abstraction
* [ ] HLS initialization
* [ ] Play/pause
* [ ] Seek
* [ ] Skip ±10 seconds
* [ ] Playback speed
* [ ] Fullscreen
* [ ] Buffering state
* [ ] Loading state
* [ ] Error handling
* [ ] Retry
* [ ] Quality selection if supported
* [ ] Player lifecycle handling

### Deliverables

A complete reusable video-player feature.

---

# Day 5 — Learning Progress

### Objectives

Connect video playback to the learning experience.

### Tasks

* [ ] Track playback position
* [ ] Persist progress
* [ ] Resume playback
* [ ] Mark lesson completed
* [ ] Calculate course progress
* [ ] Continue Learning
* [ ] Automatically suggest next lesson
* [ ] Handle background/dispose events

### Deliverables

Complete learning loop:

```text
Watch
 ↓
Save progress
 ↓
Leave
 ↓
Return
 ↓
Resume
 ↓
Complete
 ↓
Next lesson
```

---

# Day 6 — Production Quality

### Objectives

Make the application feel production-ready.

### Tasks

* [ ] Arabic localization
* [ ] RTL support
* [ ] Responsive UI
* [ ] Network error handling
* [ ] Empty states
* [ ] Loading skeletons
* [ ] Player recovery
* [ ] Logging
* [ ] Analytics abstraction
* [ ] Unit tests
* [ ] Widget tests
* [ ] Repository tests

### Deliverables

A polished application rather than a technical prototype.

---

# Day 7 — Documentation & Interview Preparation

### Objectives

Turn the project into an interview showcase.

### Tasks

* [ ] Clean code
* [ ] Refactor
* [ ] Add architecture diagram
* [ ] Document HLS pipeline
* [ ] Document trade-offs
* [ ] Document backend strategy
* [ ] Document testing strategy
* [ ] Add screenshots
* [ ] Record demo video
* [ ] Prepare interview talking points

### Deliverables

```text
GitHub Repository
+
README
+
Architecture Diagram
+
Screenshots
+
Demo Video
+
Technical Decisions
```

---

# 14. Optional Features

Only implement these if the core experience is complete.

## Offline Learning

```text
Download
   ↓
Local Storage
   ↓
Offline Playback
```

## Subtitles

Support subtitle tracks and language selection.

## Playback Analytics

Track events such as:

```text
play
pause
seek
buffer_start
buffer_end
quality_change
lesson_complete
```

## Network Awareness

Detect connectivity changes and provide appropriate UI.

## Download Manager

Allow users to download selected lessons.

---

# 15. What Will NOT Be Implemented

To keep the project focused, the following are intentionally out of scope:

* Real payment system
* Subscription management
* Admin dashboard
* Instructor dashboard
* Full authentication backend
* Production recommendation engine
* Large-scale video transcoding infrastructure
* Production DRM implementation
* Full CDN infrastructure

These can be discussed as production extensions during the interview.

---

# 16. Production Architecture Discussion

If this were developed for production at large scale, the architecture could evolve into:

```text
                    Flutter
                       │
                       ▼
                 API Gateway
                       │
              ┌────────┴────────┐
              │                 │
          Course API       Progress API
              │                 │
              ▼                 ▼
         PostgreSQL          Database
              
Video Pipeline
     │
     ▼
Upload
     │
     ▼
Transcoding
     │
     ├── 1080p
     ├── 720p
     ├── 480p
     └── 360p
     │
     ▼
Object Storage
     │
     ▼
CDN
     │
     ▼
HLS Player
```

Potential production technologies could include:

* Cloud object storage
* CDN
* FFmpeg/media processing
* Signed URLs
* DRM
* REST/GraphQL APIs
* PostgreSQL
* Redis
* Event streaming
* Analytics pipeline

The Flutter application should remain largely independent of these infrastructure choices.

---

# 17. Interview Talking Points

The project should allow discussion around:

### Flutter

* Why Riverpod?
* Why Clean Architecture?
* How is dependency injection handled?
* How is state separated from UI?
* How would you test the player?
* How would you handle app lifecycle?

### Video

* Why HLS?
* What is adaptive bitrate streaming?
* What is a master playlist?
* What are HLS segments?
* How does quality switching work?
* How would you handle buffering?
* How would you protect premium content?
* How would you use a CDN?

### E-learning

* How should learning progress be persisted?
* How do you avoid excessive progress API calls?
* How would you synchronize progress across devices?
* How would offline learning work?
* How would you track learning analytics?

### Scalability

* What happens if millions of users watch the same course?
* How does CDN reduce backend load?
* Where should video files live?
* How would you scale the API?
* How would you handle transcoding jobs?

---

# 18. Definition of Done

The project is considered complete when a user can:

```text
Open application
      ↓
Browse courses
      ↓
Open course
      ↓
Select lesson
      ↓
Play HLS video
      ↓
Change playback position
      ↓
Pause / leave
      ↓
Return later
      ↓
Resume from previous position
      ↓
Complete lesson
      ↓
See updated course progress
      ↓
Continue to next lesson
```

The application should also demonstrate:

* Clean architecture
* Riverpod
* Real HLS playback
* Adaptive streaming
* Progress persistence
* Error handling
* Arabic/English support
* Testing
* Production-oriented design

---

# 19. Primary Success Criteria

The project should prioritize:

1. **Working HLS pipeline**
2. **Excellent video-player experience**
3. **Correct learning-progress behavior**
4. **Clean Flutter architecture**
5. **Good error/lifecycle handling**
6. **Readable and testable code**
7. **Strong technical documentation**

Visual complexity and number of screens are secondary.

The goal is not to build the biggest application.

The goal is to demonstrate that I can take a core requirement of a video-learning platform and design a maintainable, production-oriented Flutter solution around it.
