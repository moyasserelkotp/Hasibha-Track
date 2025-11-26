import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../entities/debt.dart';
import '../entities/payment.dart';
import '../repositories/debt_repository.dart';

class AddPaymentParams {
  final String debtId;
  final Payment payment;

  const AddPaymentParams({
    required this.debtId,
    required this.payment,
  });
}

class AddPaymentUseCase implements UseCase<Debt, AddPaymentParams> {
  final DebtRepository repository;

  AddPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, Debt>> call(AddPaymentParams params) async {
    return await repository.addPayment(params.debtId, params.payment);
  }
}
