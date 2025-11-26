import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/reset_password_finish_usecase.dart';
import '../../../domain/usecases/reset_password_send_email_usecase.dart';
import '../../../domain/usecases/reset_password_verify_otp_usecase.dart';
import 'password_event.dart';
import 'password_state.dart';

/// BLoC for password management (reset and change)
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ResetPasswordSendEmailUseCase resetPasswordSendEmailUseCase;
  final ResetPasswordVerifyOtpUseCase resetPasswordVerifyOtpUseCase;
  final ResetPasswordFinishUseCase resetPasswordFinishUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  PasswordBloc({
    required this.resetPasswordSendEmailUseCase,
    required this.resetPasswordVerifyOtpUseCase,
    required this.resetPasswordFinishUseCase,
    required this.changePasswordUseCase,
  }) : super(const PasswordInitial()) {
    on<ResetPasswordEmailRequested>(_onResetPasswordEmailRequested);
    on<ResetPasswordOtpRequested>(_onResetPasswordOtpRequested);
    on<ResetPasswordFinishRequested>(_onResetPasswordFinishRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
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

  /// Handle password reset OTP verification
  Future<void> _onResetPasswordOtpRequested(
    ResetPasswordOtpRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    final result = await resetPasswordVerifyOtpUseCase(
      resetToken: event.resetToken,
      otp: event.otp,
    );

    result.fold(
      (failure) => emit(PasswordFailure(failure.message)),
      (message) => emit(PasswordResetOtpVerified(event.resetToken)),
    );
  }

  /// Handle password reset completion
  Future<void> _onResetPasswordFinishRequested(
    ResetPasswordFinishRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    final result = await resetPasswordFinishUseCase(
      resetToken: event.resetToken,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordFailure(failure.message)),
      (message) => emit(PasswordResetSuccess(message)),
    );
  }

  /// Handle password change request
  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    final result = await changePasswordUseCase(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordFailure(failure.message)),
      (message) => emit(PasswordChangeSuccess(message)),
    );
  }
}
