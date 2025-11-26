import '../../../../shared/core/failure.dart';

/// Authentication-specific failures

/// Invalid credentials provided
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    String message = 'Invalid username or password',
  }) : super(
          message: message,
          code: 401,
        );
}

/// User account not verified
class UserNotVerifiedFailure extends Failure {
  final String email;

  const UserNotVerifiedFailure({
    required this.email,
    String message = 'Please verify your email address',
  }) : super(
          message: message,
          code: 403,
        );

  @override
  List<Object?> get props => [...super.props, email];
}

/// Email already exists in the system
class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure({
    String message = 'This email is already registered',
  }) : super(
          message: message,
          code: 409,
        );
}

/// Username already exists
class UsernameAlreadyExistsFailure extends Failure {
  const UsernameAlreadyExistsFailure({
    String message = 'This username is already taken',
  }) : super(
          message: message,
          code: 409,
        );
}

/// Invalid OTP provided
class InvalidOtpFailure extends Failure {
  const InvalidOtpFailure({
    String message = 'Invalid OTP code',
  }) : super(
          message: message,
          code: 400,
        );
}

/// OTP has expired
class OtpExpiredFailure extends Failure {
  const OtpExpiredFailure({
    String message = 'OTP has expired. Please request a new one',
  }) : super(
          message: message,
          code: 410,
        );
}

/// Authentication token has expired
class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    String message = 'Session expired. Please login again',
  }) : super(
          message: message,
          code: 401,
        );
}

/// Invalid refresh token
class InvalidRefreshTokenFailure extends Failure {
  const InvalidRefreshTokenFailure({
    String message = 'Invalid session. Please login again',
  }) : super(
          message: message,
          code: 401,
        );
}

/// Current password doesn't match
class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure({
    String message = 'Current password is incorrect',
  }) : super(
          message: message,
          code: 400,
        );
}

/// Weak password
class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure({
    String message = 'Password is too weak. Use at least 8 characters with letters and numbers',
  }) : super(
          message: message,
          code: 400,
        );
}

/// Account suspended
class AccountSuspendedFailure extends Failure {
  const AccountSuspendedFailure({
    String message = 'Your account has been suspended. Please contact support',
  }) : super(
          message: message,
          code: 403,
        );
}

/// Reset token invalid or expired
class InvalidResetTokenFailure extends Failure {
  const InvalidResetTokenFailure({
    String message = 'Password reset link is invalid or expired',
  }) : super(
          message: message,
          code: 400,
        );
}

/// Too many attempts
class TooManyAttemptsFailure extends Failure {
  final int retryAfterSeconds;

  const TooManyAttemptsFailure({
    required this.retryAfterSeconds,
    String message = 'Too many attempts. Please try again later',
  }) : super(
          message: message,
          code: 429,
        );

  @override
  List<Object?> get props => [...super.props, retryAfterSeconds];
}
