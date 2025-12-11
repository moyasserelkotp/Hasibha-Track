import 'package:dio/dio.dart';
import '../dtos/shared_budget_dto.dart';

abstract class SharedBudgetRemoteDataSource {
  Future<List<SharedBudgetDto>> getSharedBudgets();
  Future<SharedBudgetDto> getSharedBudgetById(String id);
  Future<SharedBudgetDto> createSharedBudget(CreateSharedBudgetDto dto);
  Future<SharedBudgetDto> updateSharedBudget(String id, Map<String, dynamic> updates);
  Future<void> deleteSharedBudget(String id);
  Future<SharedBudgetDto> joinBudgetWithCode(String inviteCode);
  Future<void> inviteMember(InviteMemberDto dto);
  Future<void> removeMember(String budgetId, String userId);
  Future<void> addExpense(String budgetId, Map<String, dynamic> expense);
}

class SharedBudgetRemoteDataSourceImpl implements SharedBudgetRemoteDataSource {
  final Dio dio;
  static const String baseUrl = '/api/shared-budgets'; // Will be configured with base URL

  SharedBudgetRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SharedBudgetDto>> getSharedBudgets() async {
    try {
      final response = await dio.get(baseUrl);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SharedBudgetDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch shared budgets: $e');
    }
  }

  @override
  Future<SharedBudgetDto> getSharedBudgetById(String id) async {
    try {
      final response = await dio.get('$baseUrl/$id');
      return SharedBudgetDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to fetch shared budget: $e');
    }
  }

  @override
  Future<SharedBudgetDto> createSharedBudget(CreateSharedBudgetDto dto) async {
    try {
      final response = await dio.post(
        baseUrl,
        data: dto.toJson(),
      );
      return SharedBudgetDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to create shared budget: $e');
    }
  }

  @override
  Future<SharedBudgetDto> updateSharedBudget(String id, Map<String, dynamic> updates) async {
    try {
      final response = await dio.put(
        '$baseUrl/$id',
        data: updates,
      );
      return SharedBudgetDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to update shared budget: $e');
    }
  }

  @override
  Future<void> deleteSharedBudget(String id) async {
    try {
      await dio.delete('$baseUrl/$id');
    } catch (e) {
      throw Exception('Failed to delete shared budget: $e');
    }
  }

  @override
  Future<SharedBudgetDto> joinBudgetWithCode(String inviteCode) async {
    try {
      final response = await dio.post(
        '$baseUrl/join',
        data: {'inviteCode': inviteCode},
      );
      return SharedBudgetDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to join budget: $e');
    }
  }

  @override
  Future<void> inviteMember(InviteMemberDto dto) async {
    try {
      await dio.post(
        '$baseUrl/${dto.budgetId}/invite',
        data: {'email': dto.email, 'role': dto.role},
      );
    } catch (e) {
      throw Exception('Failed to invite member: $e');
    }
  }

  @override
  Future<void> removeMember(String budgetId, String userId) async {
    try {
      await dio.delete('$baseUrl/$budgetId/members/$userId');
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  @override
  Future<void> addExpense(String budgetId, Map<String, dynamic> expense) async {
    try {
      await dio.post(
        '$baseUrl/$budgetId/expenses',
        data: expense,
      );
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }
}

// Mock implementation for development
class MockSharedBudgetRemoteDataSource implements SharedBudgetRemoteDataSource {
  final List<SharedBudgetDto> _mockBudgets = [];

  @override
  Future<List<SharedBudgetDto>> getSharedBudgets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBudgets;
  }

  @override
  Future<SharedBudgetDto> getSharedBudgetById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBudgets.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception('Budget not found'),
    );
  }

  @override
  Future<SharedBudgetDto> createSharedBudget(CreateSharedBudgetDto dto) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final budget = SharedBudgetDto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: dto.name,
      description: dto.description,
      totalAmount: dto.totalAmount,
      spentAmount: 0,
      members: [
        {
          'userId': 'current-user-id',
          'displayName': 'You',
          'role': 'owner',
          'joinedAt': DateTime.now().toIso8601String(),
        }
      ],
      createdBy: 'current-user-id',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      periodStart: dto.periodStart,
      periodEnd: dto.periodEnd,
      visibility: 'shared',
      inviteCode: _generateInviteCode(),
      isActive: true,
    );
    
    _mockBudgets.add(budget);
    return budget;
  }

  @override
  Future<SharedBudgetDto> updateSharedBudget(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockBudgets.indexWhere((b) => b.id == id);
    if (index == -1) throw Exception('Budget not found');
    
    // In real implementation, merge updates
    return _mockBudgets[index];
  }

  @override
  Future<void> deleteSharedBudget(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBudgets.removeWhere((b) => b.id == id);
  }

  @override
  Future<SharedBudgetDto> joinBudgetWithCode(String inviteCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final budget = _mockBudgets.firstWhere(
      (b) => b.inviteCode == inviteCode,
      orElse: () => throw Exception('Invalid invite code'),
    );
    return budget;
  }

  @override
  Future<void> inviteMember(InviteMemberDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> removeMember(String budgetId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> addExpense(String budgetId, Map<String, dynamic> expense) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (index) => chars[DateTime.now().millisecond % chars.length]).join();
  }
}
