/// Login request DTO (Data Transfer Object)
/// Used to send login credentials to the API
/// Supports login with email, phone, or identifier
class LoginRequestDto {
  final String? email;
  final String? phone;
  final String? identifier;
  final String password;

  const LoginRequestDto({
    this.email,
    this.phone,
    this.identifier,
    required this.password,
  }) : assert(
          email != null || phone != null || identifier != null,
          'At least one of email, phone, or identifier must be provided',
        );

  /// Create DTO from email
  const LoginRequestDto.email({
    required String email,
    required this.password,
  })  : email = email,
        phone = null,
        identifier = null;

  /// Create DTO from phone
  const LoginRequestDto.phone({
    required String phone,
    required this.password,
  })  : email = null,
        phone = phone,
        identifier = null;

  /// Create DTO from identifier (email or phone)
  const LoginRequestDto.identifier({
    required String identifier,
    required this.password,
  })  : email = null,
        phone = null,
        identifier = identifier;

  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (identifier != null) 'identifier': identifier,
      'password': password,
    };
  }
}
