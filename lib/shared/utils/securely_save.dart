import '../core/local/cache_helper.dart';


/// Saves the refresh token securely
Future<void> saveRefreshToken(String token) async {
  await CacheHelper.saveSecureData(key: 'refresh_token', value: token);
}

/// Saves the access token securely
Future<void> saveAccessToken(String token) async {
  await CacheHelper.saveSecureData(key: 'access_token', value: token);
}

/// Gets the refresh token
Future<String?> getRefreshToken() async {
  return await CacheHelper.getSecureData(key: 'refresh_token');
}

/// Gets the access token
Future<String?> getAccessToken() async {
  return await CacheHelper.getSecureData(key: 'access_token');
}

/// Clears all authentication tokens
Future<void> clearTokens() async {
  await CacheHelper.removeSecureData(key: 'refresh_token');
  await CacheHelper.removeSecureData(key: 'access_token');
}

//