import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/savings_repository.dart';

class DeleteSavingsGoalUseCase {
  final SavingsRepository repository;

  DeleteSavingsGoalUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteSavingsGoal(id);
  }
}
