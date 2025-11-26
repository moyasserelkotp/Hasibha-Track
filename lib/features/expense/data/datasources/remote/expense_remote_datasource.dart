import 'package:dio/dio.dart';
import '../../../../../shared/core/api/api_constants.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/expense_model.dart';
import '../../models/expense_category_model.dart';
import '../../dtos/expense_dto.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  });

  Future<ExpenseModel> getExpenseById(String id);
  Future<ExpenseModel> createExpense(ExpenseDto dto);
  Future<ExpenseModel> updateExpense(String id, ExpenseDto dto);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseCategoryModel>> getCategories();
  Future<ExpenseCategoryModel> createCategory(Map<String, dynamic> categoryData);
  Future<Map<String, double>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  });
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio dio;

  ExpenseRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (tags != null && tags.isNotEmpty) queryParams['tags'] = tags.join(',');
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await dio.get(
        ApiConstants.expenses,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ExpenseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch expenses',
      );
    }
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    try {
      final response = await dio.get(
        ApiConstants.expenseById.replaceAll('{id}', id),
      );

      return ExpenseModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch expense',
      );
    }
  }

  @override
  Future<ExpenseModel> createExpense(ExpenseDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.expenses,
        data: dto.toJson(),
      );

      return ExpenseModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to create expense',
      );
    }
  }

  @override
  Future<ExpenseModel> updateExpense(String id, ExpenseDto dto) async {
    try {
      final response = await dio.put(
        ApiConstants.expenseById.replaceAll('{id}', id),
        data: dto.toJson(),
      );

      return ExpenseModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update expense',
      );
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await dio.delete(
        ApiConstants.expenseById.replaceAll('{id}', id),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete expense',
      );
    }
  }

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ExpenseCategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch categories',
      );
    }
  }

  @override
  Future<ExpenseCategoryModel> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await dio.post(
        ApiConstants.categories,
        data: categoryData,
      );

      return ExpenseCategoryModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to create category',
      );
    }
  }

  @override
  Future<Map<String, double>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.expenseStats,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'group_by': 'category',
        },
      );

      final Map<String, dynamic> data = response.data['data'] ?? response.data;
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch spending stats',
      );
    }
  }
}
