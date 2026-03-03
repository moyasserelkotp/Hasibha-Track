import 'package:equatable/equatable.dart';

/// Entity representing the status of 2FA for the user
class TwoFactorStatus extends Equatable {
  final bool enabled;
  final String? method;
  final DateTime? verifiedAt;

  const TwoFactorStatus({
    required this.enabled,
    this.method,
    this.verifiedAt,
  });

  @override
  List<Object?> get props => [enabled, method, verifiedAt];
}
