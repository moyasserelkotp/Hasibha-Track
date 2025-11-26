class LoginModelLocal {
  final String username;
  final String password;

  LoginModelLocal({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
