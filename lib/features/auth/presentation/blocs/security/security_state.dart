import 'package:equatable/equatable.dart';
import '../../../domain/entities/device.dart';
import '../../../domain/entities/two_factor_setup_response.dart';
import '../../../domain/entities/two_factor_status.dart';

abstract class SecurityState extends Equatable {
  const SecurityState();
  
  @override
  List<Object?> get props => [];
}

class SecurityInitial extends SecurityState {}

class SecurityLoading extends SecurityState {}

// 2FA States
class TwoFactorSetupInitiated extends SecurityState {
  final TwoFactorSetupResponse response;
  const TwoFactorSetupInitiated(this.response);
  @override
  List<Object?> get props => [response];
}

class TwoFactorEnabled extends SecurityState {
  final List<String> backupCodes;
  const TwoFactorEnabled(this.backupCodes);
  @override
  List<Object?> get props => [backupCodes];
}

class TwoFactorStatusLoaded extends SecurityState {
  final TwoFactorStatus status;
  const TwoFactorStatusLoaded(this.status);
  @override
  List<Object?> get props => [status];
}

class TwoFactorDisabled extends SecurityState {}

// Device States
class DevicesLoaded extends SecurityState {
  final List<Device> devices;
  const DevicesLoaded(this.devices);
  @override
  List<Object?> get props => [devices];
}

// Success State
class SecuritySuccess extends SecurityState {
  final String message;
  const SecuritySuccess(this.message);
  @override
  List<Object?> get props => [message];
}

// Error State
class SecurityFailure extends SecurityState {
  final String errorMessage;
  const SecurityFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
