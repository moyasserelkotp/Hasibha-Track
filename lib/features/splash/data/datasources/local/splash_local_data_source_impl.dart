import 'package:hasibha/features/splash/data/datasources/local/splash_local_data_source.dart';

import '../../../../../shared/core/local/cache_helper.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<bool> hasCompletedOnboarding() async {
    final result = CacheHelper.getData(key: 'onBoardingSeen');
    return result ?? false;
  }

  @override
  Future<bool> isAuthenticated() async {
    final accessToken = await CacheHelper.getSecureData(key: 'access_token');
    final refreshToken = await CacheHelper.getSecureData(key: 'refresh_token');
    
    return (accessToken != null && accessToken.isNotEmpty) ||
           (refreshToken != null && refreshToken.isNotEmpty);
  }
}
