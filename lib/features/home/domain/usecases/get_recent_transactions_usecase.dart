import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../entities/transaction.dart';
import '../repositories/home_repository.dart';

class GetRecentTransactionsUseCase {
  final HomeRepository repository;

  GetRecentTransactionsUseCase({required this.repository});

  Future<Either<Failure, List<Transaction>>> call({int limit = 10}) async {
    return await repository.getRecentTransactions(limit: limit);
  }
}
