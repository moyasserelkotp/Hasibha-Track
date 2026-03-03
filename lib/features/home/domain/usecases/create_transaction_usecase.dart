import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/transaction.dart';
import '../repositories/home_repository.dart';

class CreateTransactionUseCase {
  final HomeRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, Transaction>> call({
    required String type,
    required double amount,
    required String category,
    String? description,
    String? date,
    String? paymentMethod,
    List<String>? tags,
    String? notes,
  }) {
    return repository.createTransaction(
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
