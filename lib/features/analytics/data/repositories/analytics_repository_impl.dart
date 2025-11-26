import 'package:dartz/dartz.dart';
import '../../domain/entities/spending_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../datasources/remote/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SpendingAnalytics>> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final analytics = await remoteDataSource.getSpendingAnalytics(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(analytics);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategorySpending>>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final breakdown = await remoteDataSource.getCategoryBreakdown(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(breakdown);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DailySpending>>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final trend = await remoteDataSource.getSpendingTrend(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(trend);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MonthlySpending>>> getMonthlyComparison({
    required int year,
  }) async {
    try {
      final comparison = await remoteDataSource.getMonthlyComparison(year: year);
      return Right(comparison);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategorySpending>>> getTopCategories({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 5,
  }) async {
    try {
      final breakdown = await remoteDataSource.getCategoryBreakdown(
        startDate: startDate,
        endDate: endDate,
      );
      
      // Sort by amount descending and take top N
      final sorted = List<CategorySpending>.from(breakdown)
        ..sort((a, b) => b.amount.compareTo(a.amount));
      
      return Right(sorted.take(limit).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
