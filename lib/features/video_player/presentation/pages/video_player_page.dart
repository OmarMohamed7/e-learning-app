import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/logging/console_app_logger.dart';
import '../../../courses/data/models/video_model.dart';
import '../../../courses/presentation/providers/courses_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// One playable rendition of an HLS master playlist (e.g. "720p").
class HlsVariant {
  const HlsVariant({
    required this.uri,
    required this.height,
    required this.bandwidth,
  });

  final Uri uri;
  final int? height;
  final int bandwidth;

  String get label =>
      height != null ? '${height}p' : '${(bandwidth / 1000).round()} kbps';
}

/// Fetches [masterUrl] and parses its `#EXT-X-STREAM-INF` variants, highest
/// quality first. Variant URIs in the playlist are relative to the master
/// playlist's own location, not the site root.
Future<List<HlsVariant>> _fetchHlsVariants(String masterUrl) async {
  try {
    final response = await Dio().get<String>(
      masterUrl,
      options: Options(responseType: ResponseType.plain),
    );
    final body = response.data;
    if (body == null) return const [];

    final baseUri = Uri.parse(masterUrl);
    final lines = body.split('\n');
    final variants = <HlsVariant>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('#EXT-X-STREAM-INF:')) continue;

      final bandwidthMatch = RegExp(r'BANDWIDTH=(\d+)').firstMatch(line);
      final resolutionMatch = RegExp(r'RESOLUTION=\d+x(\d+)').firstMatch(line);

      var uriLineIndex = i + 1;
      while (uriLineIndex < lines.length &&
          (lines[uriLineIndex].trim().isEmpty ||
              lines[uriLineIndex].trim().startsWith('#'))) {
        uriLineIndex++;
      }
      if (uriLineIndex >= lines.length) continue;

      variants.add(
        HlsVariant(
          uri: baseUri.resolve(lines[uriLineIndex].trim()),
          height: resolutionMatch != null
              ? int.tryParse(resolutionMatch.group(1)!)
              : null,
          bandwidth: int.tryParse(bandwidthMatch?.group(1) ?? '') ?? 0,
        ),
      );
      i = uriLineIndex;
    }

    variants.sort((a, b) => (b.height ?? 0).compareTo(a.height ?? 0));
    return variants;
  } on Exception catch (e) {
    ConsoleAppLogger().error(
      'Failed to parse HLS variants for $masterUrl',
      error: e,
    );
    return const [];
  }
}

class VideoPlayerPage extends ConsumerStatefulWidget {
  const VideoPlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.courseTitle,
  });

  final String courseId;
  final String lessonId;
  final String courseTitle;

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String? _initializedUrl;
  late bool _initFailed;
  bool _completionMarked = false;
  bool _lastWatchedRecorded = false;

  String? _masterUrl;
  List<HlsVariant> _variants = const [];
  HlsVariant? _selectedVariant;

  /// Bumped on every `_ensureInitialized` call; lets a call detect it's been
  /// superseded by a newer one (e.g. rapid quality switches) and bail out
  /// instead of clobbering the newer controller once its own await resolves.
  int _initRequestId = 0;

  @override
  void initState() {
    super.initState();
    _initFailed = false;

    Future.microtask(() {
      ref.listenManual(courseVideosProvider(widget.courseId), (_, next) {
        next.whenData((videos) {
          final video = _findVideo(videos);
          final url = video?.masterPlaylistUrl;
          if (url != null) {
            // Only auto-initializes the first load; once a stream is
            // playing, `_selectQuality` is the sole path for switching it
            // (it needs to control autoPlay/seekTo, which this generic
            // trigger doesn't know about).
            if (_initializedUrl == null) {
              _ensureInitialized(url);
            }
            _loadVariants(url);
          }
        });
      });

      final totalLessons = ref
          .read(courseVideosProvider(widget.courseId))
          .maybeWhen(data: (videos) => videos.length, orElse: () => 0);

      _recordLastWatchedIfNeeded(totalLessons);
    });
  }

  void _recordLastWatchedIfNeeded(int totalLessons) {
    if (_lastWatchedRecorded) return;
    _lastWatchedRecorded = true;
    Future.microtask(
      () => ref
          .read(progressControllerProvider.notifier)
          .setLastWatchedCourse(
            widget.courseId,
            widget.courseTitle,
            totalLessons,
          ),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _ensureInitialized(
    String url, {
    bool autoPlay = false,
    Duration? seekTo,
  }) async {
    if (_initializedUrl == url) return;
    _initializedUrl = url;
    _completionMarked = false;
    final requestId = ++_initRequestId;

    ConsoleAppLogger().debug(
      'Video player: initializing $url (autoPlay: $autoPlay, seekTo: $seekTo)',
    );

    final oldChewie = _chewieController;
    final oldVideo = _videoController;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
    } on Exception catch (e) {
      ConsoleAppLogger().error(
        'Failed to initialize video player for $url',
        error: e,
      );
      if (!mounted || requestId != _initRequestId) return;
      setState(() => _initFailed = true);
      return;
    }

    // A newer `_ensureInitialized` call started (and possibly finished)
    // while this one was awaiting `initialize()` — e.g. rapid quality
    // switches. Drop this stale result instead of overwriting the newer
    // controller.
    if (!mounted || requestId != _initRequestId) {
      await controller.dispose();
      return;
    }

    if (seekTo != null) {
      await controller.seekTo(seekTo);
    }

    controller.addListener(_onVideoProgress);

    setState(() {
      _initFailed = false;
      _videoController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: autoPlay,
        looping: false,
        // A function, not the list itself — Chewie calls this lazily when
        // the options sheet opens, so it always reflects the latest
        // `_variants`/`_selectedVariant` even if this controller was built
        // before the playlist variants finished loading.
        additionalOptions: _buildQualityOptions,
      );
    });

    ConsoleAppLogger().debug('Video player: now playing $url');

    oldChewie?.dispose();
    await oldVideo?.dispose();
  }

  Future<void> _loadVariants(String masterUrl) async {
    if (_masterUrl == masterUrl) return;
    _masterUrl = masterUrl;

    final variants = await _fetchHlsVariants(masterUrl);
    if (!mounted) return;
    setState(() => _variants = variants);
  }

  /// Quality picks shown in Chewie's own options sheet (the three-dot menu
  /// in the player controls), alongside its built-in "Playback speed" entry.
  List<OptionItem> _buildQualityOptions(BuildContext context) {
    if (_variants.isEmpty) return const [];

    return [
      OptionItem(
        onTap: (context) {
          Navigator.pop(context);
          _selectQuality(null);
        },
        iconData: _selectedVariant == null
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        title: 'Auto',
      ),
      for (final variant in _variants)
        OptionItem(
          onTap: (context) {
            Navigator.pop(context);
            _selectQuality(variant);
          },
          iconData: _selectedVariant == variant
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          title: variant.label,
        ),
    ];
  }

  Future<void> _selectQuality(HlsVariant? variant) async {
    final masterUrl = _masterUrl;
    ConsoleAppLogger().debug(
      'Video player: quality selected -> ${variant?.label ?? "Auto"}',
    );
    if (masterUrl == null || variant == _selectedVariant) return;

    final resumePosition = _videoController?.value.position;
    final wasPlaying = _videoController?.value.isPlaying ?? false;

    setState(() => _selectedVariant = variant);

    await _ensureInitialized(
      variant?.uri.toString() ?? masterUrl,
      autoPlay: wasPlaying,
      seekTo: resumePosition,
    );
  }

  void _onVideoProgress() {
    if (_completionMarked) return;

    final controller = _videoController;
    if (controller == null) return;

    final value = controller.value;
    if (!value.isInitialized || value.duration == Duration.zero) return;

    final remaining = value.duration - value.position;
    if (remaining <= const Duration(seconds: 1)) {
      _completionMarked = true;
      ref
          .read(progressControllerProvider.notifier)
          .markLessonCompleted(
            lessonId: widget.lessonId,
            courseId: widget.courseId,
            durationSeconds: value.duration.inSeconds,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(courseVideosProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          videosAsync.maybeWhen(
            data: (videos) => _findVideo(videos)?.title ?? '',
            orElse: () => '',
          ),
        ),
      ),
      body: videosAsync.when(
        data: (videos) {
          _recordLastWatchedIfNeeded(videos.length);

          final video = _findVideo(videos);
          final masterUrl = video?.masterPlaylistUrl;
          if (video == null || masterUrl == null) {
            return Center(child: Text('genericError'.tr()));
          }

          if (_initializedUrl == null) {
            _ensureInitialized(masterUrl);
          }
          _loadVariants(masterUrl);

          if (_initFailed) {
            return Center(child: Text('genericError'.tr()));
          }

          final chewieController = _chewieController;
          final videoController = _videoController;
          if (chewieController == null || videoController == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              // Keyed by stream url so a quality switch fully remounts the
              // player instead of Chewie potentially reusing stale internal
              // state from the previous controller.
              child: Chewie(
                key: ValueKey(_initializedUrl),
                controller: chewieController,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('genericError'.tr())),
      ),
    );
  }

  VideoModel? _findVideo(List<VideoModel> videos) {
    for (final video in videos) {
      if (video.id == widget.lessonId) return video;
    }
    return null;
  }
}
