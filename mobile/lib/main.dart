import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/storage/isar_provider.dart';
import 'features/progress/data/models/last_watched_course_isar.dart';
import 'features/progress/data/models/lesson_progress_isar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final isarDirectory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [LessonProgressIsarSchema, LastWatchedCourseIsarSchema],
    directory: isarDirectory.path,
  );

  runApp(
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
}
