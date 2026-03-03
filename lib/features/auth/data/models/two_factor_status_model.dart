import 'package:equatable/equatable.dart';

/// Model representing the status of 2FA for the user
class TwoFactorStatusModel extends Equatable {
  final bool enabled;
  final String? method;
  final DateTime? verifiedAt;

  const TwoFactorStatusModel({
    required this.enabled,
    this.method,
    this.verifiedAt,
  });

  factory TwoFactorStatusModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorStatusModel(
      enabled: json['enabled'] as bool,
      method: json['method'] as String?,
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'method': method,
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [enabled, method, verifiedAt];
}
