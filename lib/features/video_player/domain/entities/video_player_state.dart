/// Explicit state model for the video player, avoiding scattered boolean
/// flags (`isLoading && !isBuffering && !hasError`, ...) throughout the UI.
/// Matches plan.md §12.
sealed class VideoPlayerState {
  const VideoPlayerState();
}

class VideoIdle extends VideoPlayerState {
  const VideoIdle();
}

class VideoInitializing extends VideoPlayerState {
  const VideoInitializing();
}

class VideoReady extends VideoPlayerState {
  const VideoReady();
}

class VideoPlaying extends VideoPlayerState {
  const VideoPlaying();
}

class VideoPaused extends VideoPlayerState {
  const VideoPaused();
}

class VideoBuffering extends VideoPlayerState {
  const VideoBuffering();
}

class VideoError extends VideoPlayerState {
  const VideoError(this.message);

  final String message;
}
