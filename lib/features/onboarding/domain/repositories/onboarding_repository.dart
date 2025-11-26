import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';


abstract class OnboardingRepository {
  /// Mark onboarding as completed
  Future<Either<Failure, bool>> completeOnboarding();
  
  /// Check if onboarding has been completed
  Future<Either<Failure, bool>> hasCompletedOnboarding();
}
