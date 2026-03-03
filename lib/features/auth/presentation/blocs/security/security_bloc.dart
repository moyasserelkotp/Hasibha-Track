import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/setup_2fa_usecase.dart';
import '../../../domain/usecases/verify_2fa_usecase.dart';
import '../../../domain/usecases/get_2fa_status_usecase.dart';
import '../../../domain/usecases/disable_2fa_usecase.dart';
import '../../../domain/usecases/get_devices_usecase.dart';
import '../../../domain/usecases/trust_device_usecase.dart';
import '../../../domain/usecases/remove_device_usecase.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final Setup2FAUseCase setup2FAUseCase;
  final Verify2FAUseCase verify2FAUseCase;
  final Get2FAStatusUseCase get2FAStatusUseCase;
  final Disable2FAUseCase disable2FAUseCase;
  final GetDevicesUseCase getDevicesUseCase;
  final TrustDeviceUseCase trustDeviceUseCase;
  final RemoveDeviceUseCase removeDeviceUseCase;

  SecurityBloc({
    required this.changePasswordUseCase,
    required this.setup2FAUseCase,
    required this.verify2FAUseCase,
    required this.get2FAStatusUseCase,
    required this.disable2FAUseCase,
    required this.getDevicesUseCase,
    required this.trustDeviceUseCase,
    required this.removeDeviceUseCase,
  }) : super(SecurityInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<Setup2FARequested>(_onSetup2FARequested);
    on<Verify2FARequested>(_onVerify2FARequested);
    on<Get2FAStatusRequested>(_onGet2FAStatusRequested);
    on<Disable2FARequested>(_onDisable2FARequested);
    on<GetDevicesRequested>(_onGetDevicesRequested);
    on<TrustDeviceRequested>(_onTrustDeviceRequested);
    on<RemoveDeviceRequested>(_onRemoveDeviceRequested);
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await changePasswordUseCase(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (_) => emit(const SecuritySuccess('Password changed successfully')),
    );
  }

  Future<void> _onSetup2FARequested(
    Setup2FARequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await setup2FAUseCase();
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (response) => emit(TwoFactorSetupInitiated(response)),
    );
  }

  Future<void> _onVerify2FARequested(
    Verify2FARequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await verify2FAUseCase(event.token);
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (backupCodes) => emit(TwoFactorEnabled(backupCodes)),
    );
  }

  Future<void> _onGet2FAStatusRequested(
    Get2FAStatusRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await get2FAStatusUseCase();
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (status) => emit(TwoFactorStatusLoaded(status)),
    );
  }

  Future<void> _onDisable2FARequested(
    Disable2FARequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await disable2FAUseCase(
      token: event.token,
      password: event.password,
    );
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (_) => emit(TwoFactorDisabled()),
    );
  }

  Future<void> _onGetDevicesRequested(
    GetDevicesRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await getDevicesUseCase();
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (devices) => emit(DevicesLoaded(devices)),
    );
  }

  Future<void> _onTrustDeviceRequested(
    TrustDeviceRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await trustDeviceUseCase(event.deviceId);
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (_) => add(GetDevicesRequested()),
    );
  }

  Future<void> _onRemoveDeviceRequested(
    RemoveDeviceRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await removeDeviceUseCase(event.deviceId);
    result.fold(
      (failure) => emit(SecurityFailure(failure.message)),
      (_) => add(GetDevicesRequested()),
    );
  }
}
