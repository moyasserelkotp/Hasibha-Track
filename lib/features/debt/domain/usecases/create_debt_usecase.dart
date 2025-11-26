import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../entities/debt.dart';
import '../repositories/debt_repository.dart';

class CreateDebtUseCase implements UseCase<Debt, Debt> {
  final DebtRepository repository;

  CreateDebtUseCase(this.repository);

  @override
  Future<Either<Failure, Debt>> call(Debt params) async {
    return await repository.createDebt(params);
  }
}
