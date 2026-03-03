import 'package:dio/dio.dart';
import '../../../features/auth/data/models/auth_tokens_model.dart';
import '../../utils/securely_save.dart';

/// Interceptor that automatically adds authentication tokens to requests
/// and handles token refresh on 401 errors (new backend contract).
class AuthInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding token for auth endpoints
    if (!_isAuthEndpoint(options.path)) {
      final accessToken = await getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path)) {
      // If already refreshing, queue this request
      if (_isRefreshing) {
        return _queueRequest(err, handler);
      }

      _isRefreshing = true;

      try {
        final refreshToken = await getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await _clearAuthAndNavigate();
          return handler.reject(err);
        }

        // Attempt to refresh the token using new API:
        // POST /api/auth/refresh-token
        // body: { "refreshToken": "<token>" }
        // response: { success, accessToken, refreshToken, ... }
        final newTokens = await _refreshToken(refreshToken);

        if (newTokens != null &&
            newTokens.accessToken.isNotEmpty &&
            newTokens.refreshToken.isNotEmpty) {
          await saveAccessToken(newTokens.accessToken);
          await saveRefreshToken(newTokens.refreshToken);

          // Retry the original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] =
              'Bearer ${newTokens.accessToken}';

          final response = await dio.fetch(opts);
          handler.resolve(response);

          // Process pending requests
          _processPendingRequests(newTokens.accessToken);
        } else {
          await _clearAuthAndNavigate();
          handler.reject(err);
        }
      } catch (e) {
        await _clearAuthAndNavigate();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
        _pendingRequests.clear();
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/signup-phone') ||
        path.contains('/auth/refresh-token') ||
        path.contains('/auth/google-signin') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/reset-password') ||
        path.contains('/auth/sms/send') ||
        path.contains('/auth/sms/verify');
  }

  void _queueRequest(DioException err, ErrorInterceptorHandler handler) {
    _pendingRequests.add(_PendingRequest(
      requestOptions: err.requestOptions,
      handler: handler,
    ));
  }

  void _processPendingRequests(String newAccessToken) {
    for (final pending in _pendingRequests) {
      pending.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      dio.fetch(pending.requestOptions).then(
        (response) => pending.handler.resolve(response),
        onError: (error) => pending.handler.reject(error as DioException),
      );
    }
  }

  Future<AuthTokensModel?> _refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: const {'Content-Type': 'application/json'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // New backend: { success, accessToken, refreshToken, ... }
        if (data['success'] == false) {
          return null;
        }

        return AuthTokensModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearAuthAndNavigate() async {
    await clearTokens();
    // Navigation will be handled by the app's auth state management
  }
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _PendingRequest({
    required this.requestOptions,
    required this.handler,
  });
}


