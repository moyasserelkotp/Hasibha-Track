import '../../domain/entities/auth_tokens.dart';

/// Auth tokens model - handles API serialization
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access'] as String? ?? '',
      refreshToken: json['refresh'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }

  /// Convert model to entity
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Create from separate token strings
  factory AuthTokensModel.fromTokens({
    required String access,
    required String refresh,
  }) {
    return AuthTokensModel(
      accessToken: access,
      refreshToken: refresh,
    );
  }
}
