import 'package:dio/dio.dart';
import 'package:hasibha/core/network/app_env.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../../domain/entities/debt_enums.dart';
import '../../models/debt_model.dart';
import '../../models/payment_model.dart';

abstract class DebtRemoteDataSource {
  Future<List<DebtModel>> getDebts({DebtType? type, DebtStatus? status});
  Future<DebtModel> getDebtById(String id);
  Future<DebtModel> createDebt(DebtModel debt);
  Future<DebtModel> updateDebt(DebtModel debt);
  Future<void> deleteDebt(String id);
  Future<DebtModel> addPayment(String debtId, PaymentModel payment);
  Future<Map<String, double>> getDebtSummary();
}

class DebtRemoteDataSourceImpl implements DebtRemoteDataSource {
  final Dio dio;

  DebtRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DebtModel>> getDebts({
    DebtType? type,
    DebtStatus? status,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (type != null) {
        queryParams['type'] = type.toString().split('.').last;
      }
      if (status != null) {
        queryParams['status'] = status.toString().split('.').last;
      }

      final response = await dio.get(
        '${AppEnv.homeBaseUrl}/api/debts',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final body = response.data;
        final List<dynamic> data =
            (body is Map<String, dynamic> ? body['debts'] : body) as List<dynamic>;
        return data
            .map((json) => DebtModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch debts',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DebtModel> getDebtById(String id) async {
    try {
      final response = await dio.get(
        '${AppEnv.homeBaseUrl}/api/debts/$id',
      );

      if (response.statusCode == 200) {
        return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch debt',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DebtModel> createDebt(DebtModel debt) async {
    try {
      final response = await dio.post(
        '${AppEnv.homeBaseUrl}/api/debts',
        data: debt.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return DebtModel.fromJson(
          (body['debt'] ?? body) as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create debt',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DebtModel> updateDebt(DebtModel debt) async {
    try {
      final response = await dio.put(
        '${AppEnv.homeBaseUrl}/api/debts/${debt.id}',
        data: debt.toJson(),
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return DebtModel.fromJson(
          (body['debt'] ?? body) as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update debt',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDebt(String id) async {
    try {
      final response = await dio.delete(
        '${AppEnv.homeBaseUrl}/api/debts/$id',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete debt',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DebtModel> addPayment(String debtId, PaymentModel payment) async {
    try {
      final response = await dio.post(
        '${AppEnv.homeBaseUrl}/api/debts/$debtId/payment',
        data: {'amount': payment.amount, 'notes': payment.notes},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return DebtModel.fromJson(
          (body['debt'] ?? body) as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to add payment',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, double>> getDebtSummary() async {
    try {
      final response = await dio.get(
        '${AppEnv.homeBaseUrl}/api/analytics/overview?period=monthly',
      );

      if (response.statusCode == 200) {
        final data = response.data['summary'] as Map<String, dynamic>;
        // Map analytics summary into a simple debt summary-like structure.
        return {
          'totalOwedToMe':
              (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
          'totalOwedByMe':
              (data['totalExpense'] as num?)?.toDouble() ?? 0.0,
          'netBalance': (data['netSavings'] as num?)?.toDouble() ?? 0.0,
        };
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch debt summary',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
