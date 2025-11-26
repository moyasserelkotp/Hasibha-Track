import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/usecases/resend_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import 'register_event.dart';
import 'register_state.dart';

/// BLoC for registration and OTP verification
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final AuthBloc authBloc;

  RegisterBloc({
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.authBloc,
  }) : super(const RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<OtpResendRequested>(_onOtpResendRequested);
  }

  /// Handle registration request
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await registerUseCase(
      username: event.username,
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      mobile: event.mobile,
    );

    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (message) => emit(RegisterSuccess(
        email: event.email,
        message: message,
      )),
    );
  }

  /// Handle OTP verification request
  Future<void> _onOtpVerificationRequested(
    OtpVerificationRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const OtpVerifying());

    final result = await verifyOtpUseCase(
      email: event.email,
      otp: event.otp,
    );

    result.fold(
      (failure) => emit(OtpFailure(failure.message)),
      (authResult) {
        // Notify global auth BLoC
        authBloc.add(AuthUserAuthenticated(authResult.user));
        
        // Emit success state
        emit(OtpVerified(authResult));
      },
    );
  }

  /// Handle OTP resend request
  Future<void> _onOtpResendRequested(
    OtpResendRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await resendOtpUseCase(event.email);

    result.fold(
      (failure) => emit(OtpFailure(failure.message)),
      (message) => emit(OtpResent(message)),
    );
  }
}
