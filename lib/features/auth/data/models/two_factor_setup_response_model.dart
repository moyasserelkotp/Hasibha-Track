import 'package:equatable/equatable.dart';

/// Model representing the response from 2FA setup initiation
class TwoFactorSetupResponseModel extends Equatable {
  final String message;
  final String qrCode;
  final String secret;
  final List<String> backupCodes;

  const TwoFactorSetupResponseModel({
    required this.message,
    required this.qrCode,
    required this.secret,
    required this.backupCodes,
  });

  factory TwoFactorSetupResponseModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorSetupResponseModel(
      message: json['message'] as String,
      qrCode: json['qrCode'] as String,
      secret: json['secret'] as String,
      backupCodes: List<String>.from(json['backupCodes'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'qrCode': qrCode,
      'secret': secret,
      'backupCodes': backupCodes,
    };
  }

  @override
  List<Object?> get props => [message, qrCode, secret, backupCodes];
}
