import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/debt.dart';
import '../entities/debt_enums.dart';
import '../entities/payment.dart';

abstract class DebtRepository {
  Future<Either<Failure, List<Debt>>> getDebts({
    DebtType? type,
    DebtStatus? status,
  });
  
  Future<Either<Failure, Debt>> getDebtById(String id);
  
  Future<Either<Failure, Debt>> createDebt(Debt debt);
  
  Future<Either<Failure, Debt>> updateDebt(Debt debt);
  
  Future<Either<Failure, void>> deleteDebt(String id);
  
  Future<Either<Failure, Debt>> addPayment(String debtId, Payment payment);
  
  Future<Either<Failure, Map<String, double>>> getDebtSummary();
}
