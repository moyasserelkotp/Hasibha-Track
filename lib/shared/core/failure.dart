import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Server failure (API errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory ServerFailure.fromStatusCode(int statusCode, String message) {
    return ServerFailure(
      message: message,
      code: statusCode,
    );
  }
}

/// Network failure (connectivity issues)
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection',
    super.details,
  }) : super(
          message: message,
          code: -1,
        );
}

/// Cache failure (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Failed to access local storage',
    super.details,
  }) : super(
          message: message,
          code: -2,
        );
}

/// Validation failure (input validation errors)
class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({
    String message = 'Validation failed',
    required this.fieldErrors,
  }) : super(
          message: message,
          code: -3,
          details: const {},
        );

  @override
  List<Object?> get props => [...super.props, fieldErrors];

  factory ValidationFailure.single(String field, String error) {
    return ValidationFailure(
      fieldErrors: {field: error},
    );
  }
}

/// Unauthorized failure (authentication required)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Authentication required',
  }) : super(
          message: message,
          code: 401,
        );
}

/// Forbidden failure (insufficient permissions)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    String message = 'Insufficient permissions',
  }) : super(
          message: message,
          code: 403,
        );
}

/// Not found failure (resource not found)
class NotFoundFailure extends Failure {
  final String? resource;

  const NotFoundFailure({
    String message = 'Resource not found',
    this.resource,
  }) : super(
          message: message,
          code: 404,
        );

  @override
  List<Object?> get props => [...super.props, resource];
}

/// Timeout failure (request timeout)
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timed out',
  }) : super(
          message: message,
          code: -4,
        );
}

/// Unknown failure (unexpected errors)
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unexpected error occurred',
    super.details,
  }) : super(
          message: message,
          code: -99,
        );
}

/// Extension for failure handling
extension FailureExtension on Failure {
  /// Get user-friendly message
  String get userMessage {
    if (this is NetworkFailure) {
      return 'Please check your internet connection';
    }
    if (this is UnauthorizedFailure) {
      return 'Please login to continue';
    }
    if (this is ValidationFailure) {
      final errors = (this as ValidationFailure).fieldErrors;
      return errors.values.first;
    }
    return message;
  }

  /// Check if failure is retryable
  bool get isRetryable {
    return this is NetworkFailure ||
        this is TimeoutFailure ||
        (this is ServerFailure && code != null && code! >= 500);
  }

  /// Check if requires logout
  bool get requiresLogout {
    return this is UnauthorizedFailure;
  }
}
