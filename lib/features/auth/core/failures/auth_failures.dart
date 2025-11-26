import '../../../../shared/core/failure.dart';

/// Authentication-specific failures

/// Invalid credentials provided
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid username or password',
  }) : super(
          code: 401,
        );
}

/// User account not verified
class UserNotVerifiedFailure extends Failure {
  final String email;

  const UserNotVerifiedFailure({
    required this.email,
    super.message = 'Please verify your email address',
  }) : super(
          code: 403,
        );

  @override
  List<Object?> get props => [...super.props, email];
}

/// Email already exists in the system
class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure({
    super.message = 'This email is already registered',
  }) : super(
          code: 409,
        );
}

/// Username already exists
class UsernameAlreadyExistsFailure extends Failure {
  const UsernameAlreadyExistsFailure({
    super.message = 'This username is already taken',
  }) : super(
          code: 409,
        );
}

/// Invalid OTP provided
class InvalidOtpFailure extends Failure {
  const InvalidOtpFailure({
    super.message = 'Invalid OTP code',
  }) : super(
          code: 400,
        );
}

/// OTP has expired
class OtpExpiredFailure extends Failure {
  const OtpExpiredFailure({
    super.message = 'OTP has expired. Please request a new one',
  }) : super(
          code: 410,
        );
}

/// Authentication token has expired
class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    super.message = 'Session expired. Please login again',
  }) : super(
          code: 401,
        );
}

/// Invalid refresh token
class InvalidRefreshTokenFailure extends Failure {
  const InvalidRefreshTokenFailure({
    super.message = 'Invalid session. Please login again',
  }) : super(
          code: 401,
        );
}

/// Current password doesn't match
class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure({
    super.message = 'Current password is incorrect',
  }) : super(
          code: 400,
        );
}

/// Weak password
class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure({
    super.message = 'Password is too weak. Use at least 8 characters with letters and numbers',
  }) : super(
          code: 400,
        );
}

/// Account suspended
class AccountSuspendedFailure extends Failure {
  const AccountSuspendedFailure({
    super.message = 'Your account has been suspended. Please contact support',
  }) : super(
          code: 403,
        );
}

/// Reset token invalid or expired
class InvalidResetTokenFailure extends Failure {
  const InvalidResetTokenFailure({
    super.message = 'Password reset link is invalid or expired',
  }) : super(
          code: 400,
        );
}

/// Too many attempts
class TooManyAttemptsFailure extends Failure {
  final int retryAfterSeconds;

  const TooManyAttemptsFailure({
    required this.retryAfterSeconds,
    super.message = 'Too many attempts. Please try again later',
  }) : super(
          code: 429,
        );

  @override
  List<Object?> get props => [...super.props, retryAfterSeconds];
}
