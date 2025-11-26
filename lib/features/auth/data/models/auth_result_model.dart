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
      user: UserModel.fromJson(json['user_info'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_info': (user as UserModel).toJson(),
      'access': tokens.accessToken,
      'refresh': tokens.refreshToken,
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
