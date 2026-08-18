import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

/// Overridden in `main()` with the awaited, opened [Isar] instance.
final Provider<Isar> isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in main()');
});
