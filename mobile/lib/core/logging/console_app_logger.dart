import 'package:logger/logger.dart';

import 'app_logger.dart';

/// [AppLogger] implementation backed by `package:logger`'s pretty console
/// output. Suitable for development; a production build could swap this for
/// a Crashlytics-backed implementation behind the same [AppLogger] interface.
class ConsoleAppLogger implements AppLogger {
  ConsoleAppLogger() : _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final Logger _logger;

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
