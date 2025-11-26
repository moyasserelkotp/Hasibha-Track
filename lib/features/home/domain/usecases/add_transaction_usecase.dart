// Use case for adding a new transaction
import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/transaction.dart';
import '../repositories/home_repository.dart';

class AddTransactionUseCase {
  final HomeRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
