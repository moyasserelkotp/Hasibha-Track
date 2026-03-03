import 'package:equatable/equatable.dart';

/// Entity representing the response from 2FA setup initiation
class TwoFactorSetupResponse extends Equatable {
  final String message;
  final String qrCode;
  final String secret;
  final List<String> backupCodes;

  const TwoFactorSetupResponse({
    required this.message,
    required this.qrCode,
    required this.secret,
    required this.backupCodes,
  });

  @override
  List<Object?> get props => [message, qrCode, secret, backupCodes];
}
