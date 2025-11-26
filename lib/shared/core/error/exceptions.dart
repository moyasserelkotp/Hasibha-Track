import '../error_model/error_server_model.dart';

/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Server/API related exceptions
class ServerException extends AppException {
  final ErrorServerModel? errorModel;
  final int? statusCode;

  const ServerException({
    required String message,
    this.errorModel,
    this.statusCode,
  }) : super(message);

  factory ServerException.fromErrorModel(ErrorServerModel errorModel) {
    return ServerException(
      message: errorModel.statusMessage,
      errorModel: errorModel,
      statusCode: errorModel.statusCode,
    );
  }
}

/// Local storage/cache related exceptions
class LocalException extends AppException {
  const LocalException(super.message);
}

/// Cache specific exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Network connectivity exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(super.message, {this.fieldErrors});
}

/// Authentication/Authorization exceptions
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

/// Not found exceptions (404)
class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

/// Unauthorized exceptions (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

/// Forbidden exceptions (403)
class ForbiddenException extends AppException {
  const ForbiddenException(super.message);
}
