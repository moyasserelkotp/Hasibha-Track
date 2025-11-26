class RegisterModelLocal {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;

  RegisterModelLocal(
      {required this.userName,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.fullName});

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'password': password,
      'password_confirm': confirmPassword,
      'full_name': fullName,
    };
  }
}

// String username,
//     String email,
// String password,
//     String mobile,
// String full_name,
//     String password_confirm
