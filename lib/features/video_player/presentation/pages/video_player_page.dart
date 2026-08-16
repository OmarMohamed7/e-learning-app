import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../courses/data/models/video_model.dart';
import '../../../courses/presentation/providers/courses_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

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
  bool _initFailed = false;
  bool _completionMarked = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(progressControllerProvider.notifier)
          .setLastWatchedCourse(widget.courseId, widget.courseTitle),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _ensureInitialized(String url) async {
    if (_initializedUrl == url) return;
    _initializedUrl = url;
    _completionMarked = false;

    final oldChewie = _chewieController;
    final oldVideo = _videoController;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
    } on Object {
      if (!mounted) return;
      setState(() => _initFailed = true);
      return;
    }
    if (!mounted) return;

    controller.addListener(_onVideoProgress);

    setState(() {
      _initFailed = false;
      _videoController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
      );
    });

    oldChewie?.dispose();
    await oldVideo?.dispose();
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
          final video = _findVideo(videos);
          final url = video?.masterPlaylistUrl;
          if (video == null || url == null) {
            return Center(child: Text('genericError'.tr()));
          }

          _ensureInitialized(url);

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
              child: Chewie(controller: chewieController),
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
