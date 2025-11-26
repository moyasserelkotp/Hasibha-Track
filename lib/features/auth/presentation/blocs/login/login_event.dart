/// Events for login functionality
abstract class LoginEvent {
  const LoginEvent();
}

/// Login with username and password
class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });
}

/// Google Sign-In requested
class GoogleSignInRequested extends LoginEvent {
  const GoogleSignInRequested();
}
