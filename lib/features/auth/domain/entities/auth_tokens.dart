import 'package:equatable/equatable.dart';

/// Authentication tokens entity
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];

  /// Check if tokens are valid (not empty)
  bool get isValid =>
      accessToken.isNotEmpty && refreshToken.isNotEmpty;

  /// Create empty tokens
  static const AuthTokens empty = AuthTokens(
    accessToken: '',
    refreshToken: '',
  );

  /// Check if tokens are empty
  bool get isEmpty => accessToken.isEmpty || refreshToken.isEmpty;
}
