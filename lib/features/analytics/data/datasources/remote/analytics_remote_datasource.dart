import 'package:dio/dio.dart';
import '../../../../../shared/core/api/api_constants.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/analytics_models.dart';

abstract class AnalyticsRemoteDataSource {
  Future<SpendingAnalyticsModel> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<CategorySpendingModel>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<DailySpendingModel>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<MonthlySpendingModel>> getMonthlyComparison({
    required int year,
  });
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final Dio dio;

  AnalyticsRemoteDataSourceImpl({required this.dio});

  @override
  Future<SpendingAnalyticsModel> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.analyticsSpending,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      return SpendingAnalyticsModel.fromJson(
        response.data['data'] ?? response.data,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch analytics',
      );
    }
  }

  @override
  Future<List<CategorySpendingModel>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.analyticsCategories,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CategorySpendingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch category breakdown',
      );
    }
  }

  @override
  Future<List<DailySpendingModel>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.analyticsTrend,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => DailySpendingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch spending trend',
      );
    }
  }

  @override
  Future<List<MonthlySpendingModel>> getMonthlyComparison({
    required int year,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.analyticsMonthly,
        queryParameters: {'year': year},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => MonthlySpendingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch monthly comparison',
      );
    }
  }
}
