import 'package:equatable/equatable.dart';

/// Entity representing a user's trusted or active device
class Device extends Equatable {
  final String id;
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String platform;
  final String browser;
  final String ipAddress;
  final String city;
  final String country;
  final DateTime lastActive;
  final bool isTrusted;
  final DateTime createdAt;

  const Device({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.platform,
    required this.browser,
    required this.ipAddress,
    required this.city,
    required this.country,
    required this.lastActive,
    required this.isTrusted,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        deviceId,
        deviceName,
        deviceType,
        platform,
        browser,
        ipAddress,
        city,
        country,
        lastActive,
        isTrusted,
        createdAt,
      ];
}
