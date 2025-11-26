import 'package:dio/dio.dart';
import '../../../../../shared/core/api/api_constants.dart';
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debts}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debtById.replaceAll('{id}', id)}',
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debts}',
        data: debt.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debtById.replaceAll('{id}', debt.id)}',
        data: debt.toJson(),
      );

      if (response.statusCode == 200) {
        return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debtById.replaceAll('{id}', id)}',
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debtPayments.replaceAll('{id}', debtId)}',
        data: payment.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
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
        '${ApiConstants.apiBaseUrl}${ApiConstants.debtSummary}',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return {
          'totalOwedToMe': (data['total_owed_to_me'] as num?)?.toDouble() ?? 0.0,
          'totalOwedByMe': (data['total_owed_by_me'] as num?)?.toDouble() ?? 0.0,
          'netBalance': (data['net_balance'] as num?)?.toDouble() ?? 0.0,
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
