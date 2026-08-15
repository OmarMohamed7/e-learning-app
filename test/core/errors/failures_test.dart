import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/core/errors/failures.dart';

void main() {
  group('Failure', () {
    test('equal failures of the same type and message compare equal', () {
      expect(const ServerFailure('boom'), equals(const ServerFailure('boom')));
    });

    test('failures with different messages are not equal', () {
      expect(
        const ServerFailure('boom'),
        isNot(equals(const ServerFailure('bang'))),
      );
    });

    test('failures of different types are not equal even with the same message', () {
      expect(
        const ServerFailure('boom'),
        isNot(equals(const NetworkFailure('boom'))),
      );
    });

    test('default messages are sensible', () {
      expect(const NotFoundFailure().message, 'Resource not found');
    });
  });
}
