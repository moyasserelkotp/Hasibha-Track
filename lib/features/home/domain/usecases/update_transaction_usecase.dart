import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/transaction.dart';
import '../repositories/home_repository.dart';

class UpdateTransactionUseCase {
  final HomeRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<Either<Failure, Transaction>> call(
    String id, {
    String? type,
    double? amount,
    String? category,
    String? description,
    String? date,
    String? paymentMethod,
    List<String>? tags,
    String? notes,
  }) {
    return repository.updateTransaction(
      id,
      type: type,
      amount: amount,
      category: category,
      description: description,
      date: date,
      paymentMethod: paymentMethod,
      tags: tags,
      notes: notes,
    );
  }
}
