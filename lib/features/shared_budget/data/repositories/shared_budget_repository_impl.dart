import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../../domain/entities/shared_budget.dart';
import '../../domain/repositories/shared_budget_repository.dart';
import '../datasources/shared_budget_remote_datasource.dart';
import '../dtos/shared_budget_dto.dart';
import '../models/budget_member_model.dart';
import '../../domain/entities/budget_member.dart';

class SharedBudgetRepositoryImpl implements SharedBudgetRepository {
  final SharedBudgetRemoteDataSource remoteDataSource;

  SharedBudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SharedBudget>>> getSharedBudgets() async {
    try {
      final dtos = await remoteDataSource.getSharedBudgets();
      final budgets = dtos.map(_dtoToEntity).toList();
      return Right(budgets);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedBudget>> getSharedBudgetById(String id) async {
    try {
      final dto = await remoteDataSource.getSharedBudgetById(id);
      return Right(_dtoToEntity(dto));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedBudget>> createSharedBudget({
    required String name,
    required String description,
    required double totalAmount,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) async {
    try {
      final dto = CreateSharedBudgetDto(
        name: name,
        description: description,
        totalAmount: totalAmount,
        periodStart: periodStart?.toIso8601String(),
        periodEnd: periodEnd?.toIso8601String(),
      );
      
      final result = await remoteDataSource.createSharedBudget(dto);
      return Right(_dtoToEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedBudget>> updateSharedBudget(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final dto = await remoteDataSource.updateSharedBudget(id, updates);
      return Right(_dtoToEntity(dto));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSharedBudget(String id) async {
    try {
      await remoteDataSource.deleteSharedBudget(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedBudget>> joinBudgetWithCode(String inviteCode) async {
    try {
      final dto = await remoteDataSource.joinBudgetWithCode(inviteCode);
      return Right(_dtoToEntity(dto));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> inviteMember({
    required String budgetId,
    required String email,
    required String role,
  }) async {
    try {
      final dto = InviteMemberDto(
        budgetId: budgetId,
        email: email,
        role: role,
      );
      await remoteDataSource.inviteMember(dto);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMember(String budgetId, String userId) async {
    try {
      await remoteDataSource.removeMember(budgetId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addExpenseToBudget({
    required String budgetId,
    required String description,
    required double amount,
    required String category,
    DateTime? date,
  }) async {
    try {
      await remoteDataSource.addExpense(budgetId, {
        'description': description,
        'amount': amount,
        'category': category,
        'date': (date ?? DateTime.now()).toIso8601String(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  SharedBudget _dtoToEntity(SharedBudgetDto dto) {
    final members = dto.members.map((m) {
      return BudgetMember(
        userId: m['userId'] ?? '',
        displayName: m['displayName'] ?? '',
        email: m['email'],
        photoUrl: m['photoUrl'],
        role: _roleFromString(m['role'] ?? 'member'),
        joinedAt: DateTime.parse(m['joinedAt'] ?? DateTime.now().toIso8601String()),
        isActive: m['isActive'] ?? true,
      );
    }).toList();

    return SharedBudget(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      totalAmount: dto.totalAmount,
      spentAmount: dto.spentAmount,
      members: members,
      createdBy: dto.createdBy,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
      periodStart: dto.periodStart != null ? DateTime.parse(dto.periodStart!) : null,
      periodEnd: dto.periodEnd != null ? DateTime.parse(dto.periodEnd!) : null,
      visibility: dto.visibility == 'private' ? BudgetVisibility.private_ : BudgetVisibility.shared,
      inviteCode: dto.inviteCode,
      isActive: dto.isActive,
    );
  }

  BudgetMemberRole _roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return BudgetMemberRole.owner;
      case 'admin':
        return BudgetMemberRole.admin;
      case 'viewer':
        return BudgetMemberRole.viewer;
      default:
        return BudgetMemberRole.member;
    }
  }
}
