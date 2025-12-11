import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../entities/shared_budget.dart';

abstract class SharedBudgetRepository {
  Future<Either<Failure, List<SharedBudget>>> getSharedBudgets();
  Future<Either<Failure, SharedBudget>> getSharedBudgetById(String id);
  Future<Either<Failure, SharedBudget>> createSharedBudget({
    required String name,
    required String description,
    required double totalAmount,
    DateTime? periodStart,
    DateTime? periodEnd,
  });
  Future<Either<Failure, SharedBudget>> updateSharedBudget(
    String id,
    Map<String, dynamic> updates,
  );
  Future<Either<Failure, void>> deleteSharedBudget(String id);
  Future<Either<Failure, SharedBudget>> joinBudgetWithCode(String inviteCode);
  Future<Either<Failure, void>> inviteMember({
    required String budgetId,
    required String email,
    required String role,
  });
  Future<Either<Failure, void>> removeMember(String budgetId, String userId);
  Future<Either<Failure, void>> addExpenseToBudget({
    required String budgetId,
    required String description,
    required double amount,
    required String category,
    DateTime? date,
  });
}
