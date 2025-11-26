import 'package:equatable/equatable.dart';
import 'auth_tokens.dart';
import 'user.dart';

/// Result of successful authentication containing user and tokens
class AuthResult extends Equatable {
  final User user;
  final AuthTokens tokens;

  const AuthResult({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object?> get props => [user, tokens];
}
