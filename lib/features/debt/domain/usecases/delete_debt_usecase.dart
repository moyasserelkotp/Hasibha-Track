import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../repositories/debt_repository.dart';

class DeleteDebtUseCase implements UseCase<void, String> {
  final DebtRepository repository;

  DeleteDebtUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteDebt(params);
  }
}
