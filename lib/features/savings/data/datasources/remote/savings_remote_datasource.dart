import 'package:dio/dio.dart';
import 'package:hasibha/core/network/app_env.dart';
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
      final response = await dio.get('${AppEnv.homeBaseUrl}/api/savings');
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        final List<dynamic> data = map['savingsGoals'] ?? const [];
        return data.map((json) => SavingsGoalModel.fromJson(json)).toList();
      }
      return [];
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
        '${AppEnv.homeBaseUrl}/api/savings/$id',
      );
      return SavingsGoalModel.fromJson(response.data as Map<String, dynamic>);
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
        '${AppEnv.homeBaseUrl}/api/savings',
        data: goal.toJson(),
      );
      return SavingsGoalModel.fromJson(
        (response.data as Map<String, dynamic>)['savingsGoal'] ??
            response.data,
      );
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
        '${AppEnv.homeBaseUrl}/api/savings/${goal.id}',
        data: goal.toJson(),
      );
      return SavingsGoalModel.fromJson(
        (response.data as Map<String, dynamic>)['savingsGoal'] ??
            response.data,
      );
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
        '${AppEnv.homeBaseUrl}/api/savings/$id',
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
        '${AppEnv.homeBaseUrl}/api/savings/$id/contribute',
        data: {'amount': amount},
      );
      return SavingsGoalModel.fromJson(
        (response.data as Map<String, dynamic>)['savingsGoal'] ??
            response.data,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to add funds',
      );
    }
  }

  @override
  Future<SavingsGoalModel> withdrawFunds(String id, double amount) async {
    try {
      // Not directly supported in new backend; simulate by negative contribution.
      final response = await dio.post(
        '${AppEnv.homeBaseUrl}/api/savings/$id/contribute',
        data: {'amount': -amount},
      );
      return SavingsGoalModel.fromJson(
        (response.data as Map<String, dynamic>)['savingsGoal'] ??
            response.data,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to withdraw funds',
      );
    }
  }
}
