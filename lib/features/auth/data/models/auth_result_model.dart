import '../../domain/entities/auth_result.dart';
import 'auth_tokens_model.dart';
import 'user_model.dart';

/// Auth result model - handles API response for authentication
class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.user,
    required super.tokens,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'accessToken': tokens.accessToken,
      'refreshToken': tokens.refreshToken,
    };
  }

  /// Convert model to entity
  AuthResult toEntity() {
    return AuthResult(
      user: (user as UserModel).toEntity(),
      tokens: (tokens as AuthTokensModel).toEntity(),
    );
  }
}
