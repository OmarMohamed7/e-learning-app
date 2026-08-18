import 'package:firebase_core/firebase_core.dart';

import '../logging/app_logger.dart';

/// Initializes Firebase, guarded so that a missing/incomplete configuration
/// never blocks app startup.
///
/// Until `flutterfire configure` has been run (which generates
/// `firebase_options.dart` and drops the native `google-services.json` /
/// `GoogleService-Info.plist` config files), this call is expected to fail —
/// that failure is logged and swallowed rather than left to crash the app,
/// since the UI must still boot to its placeholder routes either way.
Future<bool> initializeFirebase(AppLogger logger) async {
  try {
    await Firebase.initializeApp();
    logger.info('Firebase initialized.');
    return true;
  } catch (error, stackTrace) {
    logger.warning(
      'Firebase not configured yet — run `flutterfire configure` to enable '
      'Firestore/Auth. Continuing without Firebase.',
      error: error,
      stackTrace: stackTrace,
    );
    return false;
  }
}
