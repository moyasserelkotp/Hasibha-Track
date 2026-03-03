import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'app_env.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

/// Provides two configured [Dio] instances:
/// - [authDio] targeting the Auth service (port 3210)
/// - [homeDio] targeting the Home/Budget service (port 5001)
class ApiClient {
  late final Dio authDio;
  late final Dio homeDio;

  ApiClient({required TokenStorage tokenStorage}) {
    authDio = _buildDio(
      baseUrl: '${AppEnv.authBaseUrl}/api',
      tokenStorage: tokenStorage,
    );
    homeDio = _buildDio(
      baseUrl: '${AppEnv.homeBaseUrl}/api',
      tokenStorage: tokenStorage,
    );
  }

  Dio _buildDio({
    required String baseUrl,
    required TokenStorage tokenStorage,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppEnv.connectTimeout,
        receiveTimeout: AppEnv.receiveTimeout,
        sendTimeout: AppEnv.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Auth interceptor handles token injection and refresh
    dio.interceptors.add(
      AuthInterceptor(dio: dio, tokenStorage: tokenStorage),
    );

    // Logging interceptor — dev only
    if (kDebugMode) {
      dio.interceptors.add(_buildLoggingInterceptor());
    }

    return dio;
  }

  LogInterceptor _buildLoggingInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: true,
      error: true,
      logPrint: (obj) => debugPrint('[Dio] $obj'),
    );
  }
}
