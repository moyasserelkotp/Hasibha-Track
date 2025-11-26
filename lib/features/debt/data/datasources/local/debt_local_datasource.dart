import 'package:hive/hive.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../models/debt_model.dart';

abstract class DebtLocalDataSource {
  Future<List<DebtModel>> getDebts();
  Future<void> cacheDebts(List<DebtModel> debts);
  Future<void> cacheDebt(DebtModel debt);
  Future<void> deleteDebt(String id);
}

class DebtLocalDataSourceImpl implements DebtLocalDataSource {
  final Box<Map<dynamic, dynamic>> debtBox;

  DebtLocalDataSourceImpl({required this.debtBox});

  @override
  Future<List<DebtModel>> getDebts() async {
    try {
      final debts = debtBox.values.map((e) {
        return DebtModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      return debts;
    } catch (e) {
      throw CacheException('Failed to load debts');
    }
  }

  @override
  Future<void> cacheDebts(List<DebtModel> debts) async {
    try {
      await debtBox.clear();
      for (var debt in debts) {
        await debtBox.put(debt.id, debt.toJson());
      }
    } catch (e) {
      throw CacheException('Failed to cache debts');
    }
  }

  @override
  Future<void> cacheDebt(DebtModel debt) async {
    try {
      await debtBox.put(debt.id, debt.toJson());
    } catch (e) {
      throw CacheException('Failed to cache debt');
    }
  }

  @override
  Future<void> deleteDebt(String id) async {
    try {
      await debtBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete debt');
    }
  }
}
