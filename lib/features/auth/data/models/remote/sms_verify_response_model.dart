/// Model for SMS verification response
class SmsVerifyResponseModel {
  final bool success;
  final String message;
  final String? phoneVerificationToken;

  const SmsVerifyResponseModel({
    required this.success,
    required this.message,
    this.phoneVerificationToken,
  });

  factory SmsVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return SmsVerifyResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      phoneVerificationToken: json['phoneVerificationToken'],
    );
  }
}
