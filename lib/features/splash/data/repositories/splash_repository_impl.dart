import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../../../../shared/utils/routes.dart';
import '../../domain/entities/app_status.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/local/splash_local_data_source.dart';
import '../models/app_status_model.dart';


class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppStatus>> checkAppStatus() async {
    try {
      final hasCompletedOnboarding = await localDataSource.hasCompletedOnboarding();
      final isAuthenticated = await localDataSource.isAuthenticated();

      String nextRoute;
      if (!hasCompletedOnboarding) {
        nextRoute = AppRoutes.onboarding;
      } else if (!isAuthenticated) {
        nextRoute = AppRoutes.login;
      } else {
        nextRoute = AppRoutes.home;
      }

      final appStatus = AppStatusModel(
        hasCompletedOnboarding: hasCompletedOnboarding,
        isAuthenticated: isAuthenticated,
        nextRoute: nextRoute,
      );

      return Right(appStatus);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
