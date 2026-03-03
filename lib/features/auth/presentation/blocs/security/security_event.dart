import 'package:equatable/equatable.dart';
import '../../../domain/entities/device.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

// 2FA Events
class Setup2FARequested extends SecurityEvent {}
class Verify2FARequested extends SecurityEvent {
  final String token;
  const Verify2FARequested(this.token);
  @override
  List<Object?> get props => [token];
}
class Get2FAStatusRequested extends SecurityEvent {}
class Disable2FARequested extends SecurityEvent {
  final String? token;
  final String password;
  const Disable2FARequested({this.token, required this.password});
  @override
  List<Object?> get props => [token, password];
}

// Device Management Events
class GetDevicesRequested extends SecurityEvent {}
class TrustDeviceRequested extends SecurityEvent {
  final String deviceId;
  const TrustDeviceRequested(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}
class RemoveDeviceRequested extends SecurityEvent {
  final String deviceId;
  const RemoveDeviceRequested(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

// Change Password Event
class ChangePasswordRequested extends SecurityEvent {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordRequested({required this.currentPassword, required this.newPassword});
  @override
  List<Object?> get props => [currentPassword, newPassword];
}
