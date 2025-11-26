import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../entities/debt.dart';
import '../entities/debt_enums.dart';
import '../repositories/debt_repository.dart';

class GetDebtsParams {
  final DebtType? type;
  final DebtStatus? status;

  const GetDebtsParams({this.type, this.status});
}

class GetDebtsUseCase implements UseCase<List<Debt>, GetDebtsParams> {
  final DebtRepository repository;

  GetDebtsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Debt>>> call(GetDebtsParams params) async {
    return await repository.getDebts(
      type: params.type,
      status: params.status,
    );
  }
}
