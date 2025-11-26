import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../repositories/debt_repository.dart';

class GetDebtSummaryUseCase
    implements UseCase<Map<String, double>, NoParams> {
  final DebtRepository repository;

  GetDebtSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, double>>> call(NoParams params) async {
    return await repository.getDebtSummary();
  }
}
