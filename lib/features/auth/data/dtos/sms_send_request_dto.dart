/// DTO for sending SMS verification code
class SmsSendRequestDto {
  final String phone;

  const SmsSendRequestDto({required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
