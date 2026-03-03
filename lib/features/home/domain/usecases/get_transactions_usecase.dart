import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/home_repository.dart';

class GetTransactionsUseCase {
  final HomeRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    String? type,
    String? category,
    String? startDate,
    String? endDate,
    int? limit,
    int? page,
  }) {
    return repository.getTransactions(
      type: type,
      category: category,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      page: page,
    );
  }
}
