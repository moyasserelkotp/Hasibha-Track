import 'package:dartz/dartz.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../../shared/core/failure.dart';
import '../../../shared/core/exceptions.dart';
import '../datasources/remote/budget_remote_datasource.dart';
import '../datasources/local/budget_local_datasource.dart';
import '../models/budget_model.dart';
import '../dtos/budget_dto.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Budget>>> getBudgets({
    bool? isActive,
    String? categoryId,
  }) async {
    try {
      final budgets = await remoteDataSource.getBudgets(
        isActive: isActive,
        categoryId: categoryId,
      );

      await localDataSource.cacheBudgets(budgets);
      return Right(budgets.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      // Fallback to cache
      try {
        final cachedBudgets = await localDataSource.getCachedBudgets();
        if (cachedBudgets.isNotEmpty) {
          return Right(cachedBudgets.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}
      
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final budget = await remoteDataSource.getBudgetById(id);
      await localDataSource.cacheBudget(budget);
      return Right(budget.toEntity());
    } on ServerException catch (e) {
      final cachedBudget = await localDataSource.getCachedBudget(id);
      if (cachedBudget != null) {
        return Right(cachedBudget.toEntity());
      }
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget(Budget budget) async {
    try {
      final dto = BudgetDto(
        categoryId: budget.categoryId,
        limit: budget.limit,
        period: budget.period.toString().split('.').last,
        startDate: budget.startDate.toIso8601String(),
        endDate: budget.endDate.toIso8601String(),
        isActive: budget.isActive,
        alertSettings: budget.alertSettings != null
            ? {
                'enabled': budget.alertSettings!.enabled,
                'threshold': budget.alertSettings!.threshold,
                'notify_on_exceed': budget.alertSettings!.notifyOnExceed,
              }
            : null,
      );

      final createdBudget = await remoteDataSource.createBudget(dto);
      await localDataSource.cacheBudget(createdBudget);
      return Right(createdBudget.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget(Budget budget) async {
    try {
      final dto = BudgetDto(
        categoryId: budget.categoryId,
        limit: budget.limit,
        period: budget.period.toString().split('.').last,
        startDate: budget.startDate.toIso8601String(),
        endDate: budget.endDate.toIso8601String(),
        isActive: budget.isActive,
        alertSettings: budget.alertSettings != null
            ? {
                'enabled': budget.alertSettings!.enabled,
                'threshold': budget.alertSettings!.threshold,
                'notify_on_exceed': budget.alertSettings!.notifyOnExceed,
              }
            : null,
      );

      final updatedBudget = await remoteDataSource.updateBudget(budget.id, dto);
      await localDataSource.cacheBudget(updatedBudget);
      return Right(updatedBudget.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await remoteDataSource.deleteBudget(id);
      await localDataSource.deleteBudgetFromCache(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget?>> getBudgetForCategory({
    required String categoryId,
    required BudgetPeriod period,
  }) async {
    try {
      final budget = await remoteDataSource.getBudgetForCategory(
        categoryId: categoryId,
        period: period,
      );
      
      return Right(budget?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateSpentAmount({
    required String budgetId,
    required double amount,
  }) async {
    // This is typically updated by the backend when expenses are added
    // For now, we just refresh the budget
    return getBudgetById(budgetId);
  }

  @override
  Future<Either<Failure, List<Budget>>> getExceededBudgets() async {
    try {
      final budgets = await remoteDataSource.getExceededBudgets();
      return Right(budgets.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getApproachingLimitBudgets({
    double threshold = 80.0,
  }) async {
    try {
      final budgets = await remoteDataSource.getApproachingLimitBudgets(
        threshold: threshold,
      );
      return Right(budgets.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
