import 'package:hive/hive.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/savings_goal_model.dart';

abstract class SavingsLocalDataSource {
  Future<List<SavingsGoalModel>> getSavingsGoals();
  Future<void> cacheSavingsGoals(List<SavingsGoalModel> goals);
  Future<void> cacheSavingsGoal(SavingsGoalModel goal);
  Future<void> deleteSavingsGoal(String id);
}

class SavingsLocalDataSourceImpl implements SavingsLocalDataSource {
  final Box<Map<dynamic, dynamic>> savingsBox;

  SavingsLocalDataSourceImpl({required this.savingsBox});

  @override
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    try {
      final goals = savingsBox.values.map((e) {
        return SavingsGoalModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      return goals;
    } catch (e) {
      throw CacheException('Failed to fetch cached savings goals');
    }
  }

  @override
  Future<void> cacheSavingsGoals(List<SavingsGoalModel> goals) async {
    try {
      await savingsBox.clear();
      for (var goal in goals) {
        await savingsBox.put(goal.id, goal.toJson());
      }
    } catch (e) {
      throw CacheException('Failed to cache savings goals');
    }
  }

  @override
  Future<void> cacheSavingsGoal(SavingsGoalModel goal) async {
    try {
      await savingsBox.put(goal.id, goal.toJson());
    } catch (e) {
      throw CacheException('Failed to cache savings goal');
    }
  }

  @override
  Future<void> deleteSavingsGoal(String id) async {
    try {
      await savingsBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete cached savings goal');
    }
  }
}
