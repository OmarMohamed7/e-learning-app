/// Logging abstraction used throughout the app instead of calling
/// `package:logger` (or `print`) directly, so the concrete logger
/// implementation (console, Crashlytics, etc.) can be swapped without
/// touching call sites.
abstract class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});

  void info(String message, {Object? error, StackTrace? stackTrace});

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}
