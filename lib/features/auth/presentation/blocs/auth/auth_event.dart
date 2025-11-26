import '../../../domain/entities/user.dart';

/// Events for global authentication state
abstract class AuthEvent {
  const AuthEvent();
}

/// Check authentication status on app start
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

/// User has been authenticated (called by other BLoCs)
class AuthUserAuthenticated extends AuthEvent {
  final User user;

  const AuthUserAuthenticated(this.user);
}

/// User should be unauthenticated (session expired, etc.)
class AuthUserUnauthenticated extends AuthEvent {
  const AuthUserUnauthenticated();
}

/// Logout requested
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
