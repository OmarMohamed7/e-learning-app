import 'package:flutter/material.dart';

import '../../data/models/video_model.dart';

class VideoLessonCard extends StatelessWidget {
  const VideoLessonCard({
    required this.video,
    required this.index,
    this.thumbnailUrl,
    this.completed = false,
    this.onTap,
    super.key,
  });

  final VideoModel video;
  final int index;
  final String? thumbnailUrl;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = video.isReady;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        child: InkWell(
          onTap: ready ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Thumbnail(
                  thumbnailUrl: thumbnailUrl,
                  ready: ready,
                  completed: completed,
                  index: index,
                  durationSeconds: video.durationSeconds,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      if (ready)
                        Text(
                          completed ? 'Completed' : 'Lesson ${index + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: completed
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: completed ? FontWeight.w600 : null,
                          ),
                        )
                      else
                        _StatusChip(status: video.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.thumbnailUrl,
    required this.ready,
    required this.completed,
    required this.index,
    required this.durationSeconds,
  });

  final String? thumbnailUrl;
  final bool ready;
  final bool completed;
  final int index;
  final int durationSeconds;

  static const double _width = 110;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // `Row` (and the unbounded-height `ListView` it sits in) gives this
    // child unbounded width/height constraints, which `AspectRatio` can't
    // resolve on its own — it needs at least one bounded dimension.
    return SizedBox(
      width: _width,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnailUrl != null)
                Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: theme.colorScheme.primaryContainer),
                )
              else
                Container(color: theme.colorScheme.primaryContainer),
              if (!ready)
                Container(color: Colors.black.withValues(alpha: 0.45)),
              Center(
                child: Icon(
                  ready ? Icons.play_circle_fill_rounded : Icons.hourglass_top,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Positioned(
                left: 6,
                top: 6,
                child: completed
                    ? const _CompletedBadge()
                    : _Pill(text: '${index + 1}'),
              ),
              if (ready)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: _Pill(text: _formatDuration(durationSeconds)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 12),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = status == 'error';
    final color = isError
        ? theme.colorScheme.error
        : theme.colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
