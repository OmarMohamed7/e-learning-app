/// Base type for exceptions thrown by the data layer (repositories, data
/// sources). Repositories catch these and map them to [Failure]s before
/// returning control to the domain/presentation layers.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No network connection']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local cache error']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}
