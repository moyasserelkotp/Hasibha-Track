import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/reset_password_send_email_usecase.dart';
import '../../../domain/usecases/reset_password_usecase.dart';
import 'password_event.dart';
import 'password_state.dart';

/// BLoC for password management (reset)
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ResetPasswordSendEmailUseCase resetPasswordSendEmailUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  PasswordBloc({
    required this.resetPasswordSendEmailUseCase,
    required this.resetPasswordUseCase,
  }) : super(const PasswordInitial()) {
    on<ResetPasswordEmailRequested>(_onResetPasswordEmailRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  /// Handle password reset email request
  Future<void> _onResetPasswordEmailRequested(
    ResetPasswordEmailRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    final result = await resetPasswordSendEmailUseCase(event.email);

    result.fold(
      (failure) => emit(PasswordFailure(failure.message)),
      (message) => emit(PasswordResetEmailSent(message)),
    );
  }

  /// Handle password reset completion
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    final result = await resetPasswordUseCase(
      email: event.email,
      code: event.code,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordFailure(failure.message)),
      (message) => emit(PasswordResetSuccess(message)),
    );
  }
}
