import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/local/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> completeOnboarding() async {
    try {
      final result = await localDataSource.saveOnboardingCompletion();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message:e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCompletedOnboarding() async {
    try {
      final result = await localDataSource.hasCompletedOnboarding();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message:e.toString()));
    }
  }
}
