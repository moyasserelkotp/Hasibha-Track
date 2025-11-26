import 'package:dartz/dartz.dart';

import '../../../../shared/core/error/exceptions.dart';
import '../../../../shared/core/failure.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_data_source.dart';
import '../datasources/local/home_local_data_source.dart';
import '../models/transaction_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // -----------------------------------------------------------
  // Dashboard Summary
  // -----------------------------------------------------------
  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    try {
      // Get local transactions
      final transactions = await localDataSource.getTransactions();

      double totalIncome = 0;
      double totalExpense = 0;

      for (final t in transactions) {
        if (t.type == 'income') {
          totalIncome += t.amount;
        } else {
          totalExpense += t.amount;
        }
      }

      final totalBalance = totalIncome - totalExpense;

      final recentTransactions =
      await localDataSource.getRecentTransactions(limit: 10);

      return Right(
        DashboardSummary(
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          recentTransactions: recentTransactions,
          categoryBreakdown: {},
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -----------------------------------------------------------
  // Recent Transactions (Remote)
  // -----------------------------------------------------------
  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions(
      {int limit = 10}) async {
    try {
      final result = await remoteDataSource.getRecentTransactions(limit: limit);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -----------------------------------------------------------
  // Add Transaction (Local)
  // -----------------------------------------------------------
  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await localDataSource.addTransaction(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -----------------------------------------------------------
  // Analytics
  // -----------------------------------------------------------
  @override
  Future<Either<Failure, AnalyticsData>> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final allTransactions = await localDataSource.getTransactions();

      final end = endDate ?? DateTime.now();
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 90));

      final filtered = allTransactions.where((t) {
        return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1)));
      }).toList();

      final Map<String, double> categoryBreakdown = {};
      double totalIncome = 0;
      double totalExpense = 0;

      for (final t in filtered) {
        if (t.type == 'expense') {
          categoryBreakdown[t.category] =
              (categoryBreakdown[t.category] ?? 0) + t.amount;
          totalExpense += t.amount;
        } else {
          totalIncome += t.amount;
        }
      }

      // Top spending category
      String topCategory = '';
      double topAmount = 0;

      categoryBreakdown.forEach((category, amount) {
        if (amount > topAmount) {
          topAmount = amount;
          topCategory = category;
        }
      });

      // Monthly trends
      final Map<String, MonthlyData> monthlyTrendsMap = {};

      for (final t in filtered) {
        final key =
            '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';

        if (!monthlyTrendsMap.containsKey(key)) {
          monthlyTrendsMap[key] = MonthlyData(
            month: key,
            income: 0,
            expense: 0,
            savings: 0,
          );
        }

        final trend = monthlyTrendsMap[key]!;

        final newIncome = trend.income + (t.type == 'income' ? t.amount : 0);
        final newExpense = trend.expense + (t.type == 'expense' ? t.amount : 0);

        monthlyTrendsMap[key] = MonthlyData(
          month: key,
          income: newIncome,
          expense: newExpense,
          savings: newIncome - newExpense,
        );
      }

      final monthlyTrends = monthlyTrendsMap.values.toList()
        ..sort((a, b) => a.month.compareTo(b.month));

      return Right(
        AnalyticsData(
          categoryBreakdown: categoryBreakdown,
          monthlyTrends: monthlyTrends,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          netSavings: totalIncome - totalExpense,
          topSpendingCategory: topCategory.isEmpty ? 'None' : topCategory,
          startDate: start,
          endDate: end,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
