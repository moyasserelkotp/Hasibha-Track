import 'dart:convert';
import '../../../../shared/utils/utils.dart' as localDataSource;


class TokenService {
  /// Get access token
  Future<String?> getAccessToken() async {
    return await localDataSource.getAccessToken();
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await localDataSource.getRefreshToken();
  }

  /// Get both tokens
  // Future<AuthTokens?> getTokens() async {
  //   // final tokensModel = await localDataSource.getTokens();
  //   // return tokensModel?.toEntity();
  // }

  /// Check if user has valid tokens
  // Future<bool> hasValidTokens() async {
  //   return await localDataSource.hasValidSession();
  // }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await localDataSource.clearTokens();
  }

  /// Check if access token is expired (JWT)
  bool isTokenExpired(String token) {
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);

      if (!payloadMap.containsKey('exp')) return false;

      final exp = payloadMap['exp'] as int;
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  /// Check if token will expire within a threshold
  bool isTokenExpiringSoon(
      String token, {
        Duration threshold = const Duration(minutes: 5),
      }) {
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);

      if (!payloadMap.containsKey('exp')) return false;

      final exp = payloadMap['exp'] as int;
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiryDate.subtract(threshold));
    } catch (e) {
      return true;
    }
  }
}
