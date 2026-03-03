import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/home_repository.dart';

class DeleteTransactionUseCase {
  final HomeRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTransaction(id);
  }
}
