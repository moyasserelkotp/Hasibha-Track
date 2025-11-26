import 'package:dio/dio.dart';
import '../../../domain/entities/budget.dart';
import '../../../../../shared/core/api/api_constants.dart';
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
      if (isActive != null) queryParams['is_active'] = isActive;
      if (categoryId != null) queryParams['category_id'] = categoryId;

      final response = await dio.get(
        ApiConstants.budgets,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudgetModel.fromJson(json)).toList();
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
        ApiConstants.budgetById.replaceAll('{id}', id),
      );

      return BudgetModel.fromJson(response.data['data'] ?? response.data);
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
        ApiConstants.budgets,
        data: dto.toJson(),
      );

      return BudgetModel.fromJson(response.data['data'] ?? response.data);
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
        ApiConstants.budgetById.replaceAll('{id}', id),
        data: dto.toJson(),
      );

      return BudgetModel.fromJson(response.data['data'] ?? response.data);
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
        ApiConstants.budgetById.replaceAll('{id}', id),
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
      final periodStr = period.toString().split('.').last;
      final response = await dio.get(
        ApiConstants.budgetByCategory.replaceAll('{categoryId}', categoryId),
        queryParameters: {'period': periodStr},
      );

      if (response.data == null || response.data['data'] == null) {
        return null;
      }

      return BudgetModel.fromJson(response.data['data']);
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
      final response = await dio.get(ApiConstants.budgetExceeded);

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudgetModel.fromJson(json)).toList();
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
      final response = await dio.get(
        ApiConstants.budgetApproaching,
        queryParameters: {'threshold': threshold},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch approaching budgets',
      );
    }
  }
}
