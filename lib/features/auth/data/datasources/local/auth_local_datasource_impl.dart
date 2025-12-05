import 'dart:convert';

import '../../../../../shared/core/local/cache_helper.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementation of local data source using CacheHelper
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // Cache keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserData = 'user_data';

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await CacheHelper.saveSecureData(
      key: _keyAccessToken,
      value: tokens.accessToken,
    );
    await CacheHelper.saveSecureData(
      key: _keyRefreshToken,
      value: tokens.refreshToken,
    );
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    final accessToken = await CacheHelper.getSecureData(key: _keyAccessToken);
    final refreshToken = await CacheHelper.getSecureData(key: _keyRefreshToken);

    if (accessToken != null && refreshToken != null) {
      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    return await CacheHelper.getSecureData(key: _keyAccessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await CacheHelper.getSecureData(key: _keyRefreshToken);
  }

  @override
  Future<bool> hasValidSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    
    return accessToken != null && 
           refreshToken != null && 
           accessToken.isNotEmpty && 
           refreshToken.isNotEmpty;
  }

  @override
  Future<void> clearTokens() async {
    await CacheHelper.removeSecureData(key: _keyAccessToken);
    await CacheHelper.removeSecureData(key: _keyRefreshToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await CacheHelper.saveData(key: _keyUserData, value: userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = CacheHelper.getData(key: _keyUserData);
    if (userJson != null && userJson is String) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await CacheHelper.removeData(key: _keyUserData);
  }
}
