import 'package:dartz/dartz.dart';
import '../repositories/onboarding_repository.dart';
import '../../../../shared/core/failure.dart';

class CheckOnboardingStatusUseCase {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase({required this.repository});

  Future<Either<Failure, bool>> call() async {
    return await repository.hasCompletedOnboarding();
  }
}
