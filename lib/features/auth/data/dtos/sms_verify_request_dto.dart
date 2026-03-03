/// DTO for verifying SMS code
class SmsVerifyRequestDto {
  final String phone;
  final String code;

  const SmsVerifyRequestDto({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }
}
