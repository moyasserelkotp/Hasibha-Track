import 'package:equatable/equatable.dart';

/// Model representing a user's trusted or active device
class DeviceModel extends Equatable {
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

  const DeviceModel({
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

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    return DeviceModel(
      id: json['_id'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      platform: json['platform'] as String,
      browser: json['browser'] as String,
      ipAddress: json['ipAddress'] as String,
      city: location['city'] as String? ?? 'Unknown',
      country: location['country'] as String? ?? 'Unknown',
      lastActive: DateTime.parse(json['lastActive'] as String),
      isTrusted: json['isTrusted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'platform': platform,
      'browser': browser,
      'ipAddress': ipAddress,
      'location': {
        'city': city,
        'country': country,
      },
      'lastActive': lastActive.toIso8601String(),
      'isTrusted': isTrusted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

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
