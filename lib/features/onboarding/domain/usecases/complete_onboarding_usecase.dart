import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/onboarding_repository.dart';


class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase({required this.repository});

  Future<Either<Failure, bool>> call() async {
    return await repository.completeOnboarding();
  }
}
