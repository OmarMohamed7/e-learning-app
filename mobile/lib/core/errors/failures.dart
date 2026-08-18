import 'package:equatable/equatable.dart';

/// Presentation-facing counterpart to [AppException]. Repositories catch
/// exceptions thrown by data sources and surface a [Failure] instead, so the
/// domain/presentation layers never depend on data-layer exception types.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No network connection']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
