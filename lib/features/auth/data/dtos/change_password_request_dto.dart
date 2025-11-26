/// Change password request DTO
/// Used to change user password
class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': currentPassword,
      'new_password': newPassword,
    };
  }
}
