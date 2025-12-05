/// Events for login functionality
abstract class LoginEvent {
  const LoginEvent();
}

/// Login with identifier (email or phone) and password
class LoginRequested extends LoginEvent {
  final String identifier;
  final String password;

  const LoginRequested({
    required this.identifier,
    required this.password,
  });
}

/// Google Sign-In requested
class GoogleSignInRequested extends LoginEvent {
  final String idToken;
  
  const GoogleSignInRequested({required this.idToken});
}
