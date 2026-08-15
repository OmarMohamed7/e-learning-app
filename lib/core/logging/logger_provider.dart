import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';
import 'console_app_logger.dart';

final Provider<AppLogger> appLoggerProvider = Provider<AppLogger>((ref) {
  return ConsoleAppLogger();
});
