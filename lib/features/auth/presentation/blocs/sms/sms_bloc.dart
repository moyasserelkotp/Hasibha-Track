import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/send_sms_usecase.dart';
import '../../../domain/usecases/verify_sms_usecase.dart';
import '../../../../../shared/core/error/exceptions.dart';
import 'sms_event.dart';
import 'sms_state.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final SendSmsUseCase sendSmsUseCase;
  final VerifySmsUseCase verifySmsUseCase;

  SmsBloc({
    required this.sendSmsUseCase,
    required this.verifySmsUseCase,
  }) : super(const SmsInitial()) {
    on<SendSmsRequested>(_onSendSmsRequested);
    on<VerifySmsRequested>(_onVerifySmsRequested);
    on<SmsReset>(_onSmsReset);
  }

  Future<void> _onSendSmsRequested(
    SendSmsRequested event,
    Emitter<SmsState> emit,
  ) async {
    emit(const SmsLoading());

    final result = await sendSmsUseCase(event.phone);

    result.fold(
      (failure) {
        // Handle rate limiting if possible, though clean architecture usually abstracts this
        emit(SmsFailure(failure.message));
      },
      (success) {
        if (success) {
          emit(const SmsCodeSent('Code sent successfully'));
        } else {
          emit(const SmsFailure('Failed to send code'));
        }
      },
    );
  }

  Future<void> _onVerifySmsRequested(
    VerifySmsRequested event,
    Emitter<SmsState> emit,
  ) async {
    emit(const SmsLoading());

    final result = await verifySmsUseCase(
      phone: event.phone,
      code: event.code,
    );

    result.fold(
      (failure) => emit(SmsFailure(failure.message)),
      (token) => emit(SmsVerified(token)),
    );
  }

  void _onSmsReset(SmsReset event, Emitter<SmsState> emit) {
    emit(const SmsInitial());
  }
}
