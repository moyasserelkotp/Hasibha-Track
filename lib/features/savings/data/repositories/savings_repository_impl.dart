import 'package:dartz/dartz.dart';
import 'dart:async';

import '../../../../shared/core/failure.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_repository.dart';
import '../datasources/local/savings_local_datasource.dart';
import '../datasources/remote/savings_remote_datasource.dart';
import '../models/savings_goal_model.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final SavingsRemoteDataSource remoteDataSource;
  final SavingsLocalDataSource localDataSource;

  SavingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ---------------------------------------------------------------------------
  // GET ALL SAVINGS GOALS
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals() async {
    try {
      final remoteGoals = await remoteDataSource.getSavingsGoals();
      await localDataSource.cacheSavingsGoals(remoteGoals);
      return Right(remoteGoals);
    } on NetworkException {
      // fallback to cache
      try {
        final localGoals = await localDataSource.getSavingsGoals();
        if (localGoals.isNotEmpty) return Right(localGoals);
      } catch (_) {}
      return const Left(NetworkFailure());
    } on TimeoutException {
      // fallback to cache
      try {
        final localGoals = await localDataSource.getSavingsGoals();
        if (localGoals.isNotEmpty) return Right(localGoals);
      } catch (_) {}
      return const Left(TimeoutFailure());
    } on ServerException catch (e) {
      // fallback to cache
      try {
        final localGoals = await localDataSource.getSavingsGoals();
        if (localGoals.isNotEmpty) return Right(localGoals);
      } catch (_) {}
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      // fallback to cache
      try {
        final localGoals = await localDataSource.getSavingsGoals();
        if (localGoals.isNotEmpty) return Right(localGoals);
      } catch (_) {}
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // GET SAVINGS GOAL BY ID
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, SavingsGoal>> getSavingsGoalById(String id) async {
    try {
      final goal = await remoteDataSource.getSavingsGoalById(id);
      return Right(goal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // CREATE SAVINGS GOAL
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, SavingsGoal>> createSavingsGoal(SavingsGoal goal) async {
    try {
      final model = SavingsGoalModel.fromEntity(goal);
      final createdGoal = await remoteDataSource.createSavingsGoal(model);

      await localDataSource.cacheSavingsGoal(createdGoal);
      return Right(createdGoal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE SAVINGS GOAL
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final model = SavingsGoalModel.fromEntity(goal);
      final updatedGoal = await remoteDataSource.updateSavingsGoal(model);

      await localDataSource.cacheSavingsGoal(updatedGoal);
      return Right(updatedGoal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE SAVINGS GOAL
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, void>> deleteSavingsGoal(String id) async {
    try {
      await remoteDataSource.deleteSavingsGoal(id);
      await localDataSource.deleteSavingsGoal(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // ADD FUNDS
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, SavingsGoal>> addFunds(String id, double amount) async {
    try {
      final updatedGoal = await remoteDataSource.addFunds(id, amount);

      await localDataSource.cacheSavingsGoal(updatedGoal);
      return Right(updatedGoal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // WITHDRAW FUNDS
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, SavingsGoal>> withdrawFunds(String id, double amount) async {
    try {
      final updatedGoal = await remoteDataSource.withdrawFunds(id, amount);

      await localDataSource.cacheSavingsGoal(updatedGoal);
      return Right(updatedGoal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
