import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/debt_repository.dart';
import '../datasources/local/debt_local_datasource.dart';
import '../datasources/remote/debt_remote_datasource.dart';
import '../models/debt_model.dart';
import '../models/payment_model.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtRemoteDataSource remoteDataSource;
  final DebtLocalDataSource localDataSource;

  DebtRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Debt>>> getDebts({
    DebtType? type,
    DebtStatus? status,
  }) async {
    try {
      final remoteDebts = await remoteDataSource.getDebts(
        type: type,
        status: status,
      );
      await localDataSource.cacheDebts(remoteDebts);
      return Right(remoteDebts);
    } on NetworkException catch (_) {
      // Network error - try cache
      try {
        final localDebts = await localDataSource.getDebts();
        if (localDebts.isNotEmpty) {
          return Right(localDebts);
        }
      } catch (_) {}
      return const Left(NetworkFailure());
    } on TimeoutException catch (_) {
      // Timeout - try cache
      try {
        final localDebts = await localDataSource.getDebts();
        if (localDebts.isNotEmpty) {
          return Right(localDebts);
        }
      } catch (_) {}
      return const Left(TimeoutFailure());
    } on ServerException catch (e) {
      // Fallback to local cache
      try {
        final localDebts = await localDataSource.getDebts();
        if (localDebts.isNotEmpty) {
          return Right(localDebts);
        }
        return Left(ServerFailure(message: e.message));
      } catch (cacheError) {
        return Left(ServerFailure(message: e.message));
      }
    } catch (e) {
      // Fallback to local cache
      try {
        final localDebts = await localDataSource.getDebts();
        if (localDebts.isNotEmpty) {
          return Right(localDebts);
        }
        return Left(ServerFailure(message: e.toString()));
      } catch (cacheError) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Debt>> getDebtById(String id) async {
    try {
      final debt = await remoteDataSource.getDebtById(id);
      return Right(debt);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Debt>> createDebt(Debt debt) async {
    try {
      final debtModel = DebtModel.fromEntity(debt);
      final createdDebt = await remoteDataSource.createDebt(debtModel);
      await localDataSource.cacheDebt(createdDebt);
      return Right(createdDebt);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Debt>> updateDebt(Debt debt) async {
    try {
      final debtModel = DebtModel.fromEntity(debt);
      final updatedDebt = await remoteDataSource.updateDebt(debtModel);
      await localDataSource.cacheDebt(updatedDebt);
      return Right(updatedDebt);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDebt(String id) async {
    try {
      await remoteDataSource.deleteDebt(id);
      await localDataSource.deleteDebt(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Debt>> addPayment(String debtId, Payment payment) async {
    try {
      final paymentModel = PaymentModel.fromEntity(payment);
      final updatedDebt = await remoteDataSource.addPayment(debtId, paymentModel);
      await localDataSource.cacheDebt(updatedDebt);
      return Right(updatedDebt);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getDebtSummary() async {
    try {
      final summary = await remoteDataSource.getDebtSummary();
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
