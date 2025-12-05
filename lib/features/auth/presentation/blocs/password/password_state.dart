import 'package:equatable/equatable.dart';

/// States for password management
abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PasswordInitial extends PasswordState {
  const PasswordInitial();
}

/// Password operation in progress
class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

/// Password reset email sent successfully
class PasswordResetEmailSent extends PasswordState {
  final String message;

  const PasswordResetEmailSent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Password reset completed successfully
class PasswordResetSuccess extends PasswordState {
  final String message;

  const PasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Password operation failed
class PasswordFailure extends PasswordState {
  final String message;

  const PasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
