import 'package:dio/dio.dart';
import '../../../../../shared/core/api/api_constants.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/savings_goal_model.dart';

abstract class SavingsRemoteDataSource {
  Future<List<SavingsGoalModel>> getSavingsGoals();
  Future<SavingsGoalModel> getSavingsGoalById(String id);
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel goal);
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel goal);
  Future<void> deleteSavingsGoal(String id);
  Future<SavingsGoalModel> addFunds(String id, double amount);
  Future<SavingsGoalModel> withdrawFunds(String id, double amount);
}

class SavingsRemoteDataSourceImpl implements SavingsRemoteDataSource {
  final Dio dio;

  SavingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    try {
      final response = await dio.get(ApiConstants.savingsGoals);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SavingsGoalModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch savings goals',
      );
    }
  }

  @override
  Future<SavingsGoalModel> getSavingsGoalById(String id) async {
    try {
      final response = await dio.get(
        ApiConstants.savingsGoalById.replaceAll('{id}', id),
      );
      return SavingsGoalModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch savings goal',
      );
    }
  }

  @override
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel goal) async {
    try {
      final response = await dio.post(
        ApiConstants.savingsGoals,
        data: goal.toJson(),
      );
      return SavingsGoalModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to create savings goal',
      );
    }
  }

  @override
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel goal) async {
    try {
      final response = await dio.put(
        ApiConstants.savingsGoalById.replaceAll('{id}', goal.id),
        data: goal.toJson(),
      );
      return SavingsGoalModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update savings goal',
      );
    }
  }

  @override
  Future<void> deleteSavingsGoal(String id) async {
    try {
      await dio.delete(
        ApiConstants.savingsGoalById.replaceAll('{id}', id),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete savings goal',
      );
    }
  }

  @override
  Future<SavingsGoalModel> addFunds(String id, double amount) async {
    try {
      final response = await dio.post(
        ApiConstants.savingsGoalAddFunds.replaceAll('{id}', id),
        data: {'amount': amount},
      );
      return SavingsGoalModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to add funds',
      );
    }
  }

  @override
  Future<SavingsGoalModel> withdrawFunds(String id, double amount) async {
    try {
      final response = await dio.post(
        ApiConstants.savingsGoalWithdraw.replaceAll('{id}', id),
        data: {'amount': amount},
      );
      return SavingsGoalModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to withdraw funds',
      );
    }
  }
}
