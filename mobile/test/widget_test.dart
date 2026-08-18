import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mentor_stream_flutter/app/app.dart';
import 'package:mentor_stream_flutter/core/storage/isar_provider.dart';
import 'package:mentor_stream_flutter/features/progress/data/models/last_watched_course_isar.dart';
import 'package:mentor_stream_flutter/features/progress/data/models/lesson_progress_isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory isarDirectory;
  late Isar isar;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    isarDirectory = await Directory.systemTemp.createTemp(
      'mentor_stream_flutter_test_isar',
    );
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [LessonProgressIsarSchema, LastWatchedCourseIsarSchema],
      directory: isarDirectory.path,
    );
  });

  tearDownAll(() async {
    await isar.close();
    await isarDirectory.delete(recursive: true);
  });

  testWidgets('MentorStreamApp boots to the Home placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ProviderScope(
          overrides: [isarProvider.overrideWithValue(isar)],
          child: const MentorStreamApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
  });
}
