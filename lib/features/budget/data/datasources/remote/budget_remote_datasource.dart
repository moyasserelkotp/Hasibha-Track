import 'package:dio/dio.dart';
import 'package:hasibha/core/network/app_env.dart';
import '../../../domain/entities/budget.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/budget_model.dart';
import '../../dtos/budget_dto.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets({bool? isActive, String? categoryId});
  Future<BudgetModel> getBudgetById(String id);
  Future<BudgetModel> createBudget(BudgetDto dto);
  Future<BudgetModel> updateBudget(String id, BudgetDto dto);
  Future<void> deleteBudget(String id);
  Future<BudgetModel?> getBudgetForCategory({
    required String categoryId,
    required BudgetPeriod period,
  });
  Future<List<BudgetModel>> getExceededBudgets();
  Future<List<BudgetModel>> getApproachingLimitBudgets({double threshold = 80.0});
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final Dio dio;

  BudgetRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BudgetModel>> getBudgets({
    bool? isActive,
    String? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isActive != null) queryParams['isActive'] = isActive;
      if (categoryId != null) queryParams['category'] = categoryId;

      final response = await dio.get(
        '${AppEnv.homeBaseUrl}/api/budgets',
        queryParameters: queryParams,
      );

      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        final List<dynamic> data = map['budgets'] ?? const [];
        return data.map((json) => BudgetModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch budgets',
      );
    }
  }

  @override
  Future<BudgetModel> getBudgetById(String id) async {
    try {
      final response = await dio.get(
        '${AppEnv.homeBaseUrl}/api/budgets/$id',
      );

      return BudgetModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch budget',
      );
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetDto dto) async {
    try {
      final response = await dio.post(
        '${AppEnv.homeBaseUrl}/api/budgets',
        data: dto.toJson(),
      );

      return BudgetModel.fromJson(response.data['budget'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to create budget',
      );
    }
  }

  @override
  Future<BudgetModel> updateBudget(String id, BudgetDto dto) async {
    try {
      final response = await dio.put(
        '${AppEnv.homeBaseUrl}/api/budgets/$id',
        data: dto.toJson(),
      );

      return BudgetModel.fromJson(response.data['budget'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update budget',
      );
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    try {
      await dio.delete(
        '${AppEnv.homeBaseUrl}/api/budgets/$id',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete budget',
      );
    }
  }

  @override
  Future<BudgetModel?> getBudgetForCategory({
    required String categoryId,
    required BudgetPeriod period,
  }) async {
    try {
      // Not directly supported by new backend; derive from list.
      final budgets = await getBudgets(isActive: true, categoryId: categoryId);
      if (budgets.isEmpty) return null;
      // Simple heuristic: return first matching budget.
      return budgets.first;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch budget',
      );
    }
  }

  @override
  Future<List<BudgetModel>> getExceededBudgets() async {
    try {
      // Not provided as a separate endpoint in new backend.
      // Fetch active budgets and filter by percentageSpent >= 100.
      final budgets = await getBudgets(isActive: true);
      return budgets
          .where((b) => (b.percentageSpent ?? 0) >= 100)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch exceeded budgets',
      );
    }
  }

  @override
  Future<List<BudgetModel>> getApproachingLimitBudgets({
    double threshold = 80.0,
  }) async {
    try {
      // Not provided as separate endpoint in new backend.
      // Fetch active budgets and filter by percentageSpent >= threshold.
      final budgets = await getBudgets(isActive: true);
      return budgets
          .where((b) => (b.percentageSpent ?? 0) >= threshold)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch approaching budgets',
      );
    }
  }
}
