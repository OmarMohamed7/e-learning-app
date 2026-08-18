import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/video_model.dart';
import 'package:mentor_stream_flutter/features/courses/presentation/widgets/video_lesson_card.dart';

void main() {
  const video = VideoModel(
    id: 'video-1',
    title: 'Intro to Widgets',
    courseId: 'course-1',
    status: 'ready',
    hlsUrl: '/media/video-1/master.m3u8',
    durationSeconds: 125,
  );

  testWidgets(
    'renders inside a ListView without throwing (regression: AspectRatio '
    'needs a bounded width when placed in an unbounded-height ListView row)',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                VideoLessonCard(video: video, index: 0),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Intro to Widgets'), findsOneWidget);
    },
  );
}
