import 'package:equatable/equatable.dart';
import 'budget_member.dart';

enum BudgetVisibility {
  private_,
  shared,
}

class SharedBudget extends Equatable {
  final String id;
  final String name;
  final String description;
  final double totalAmount;
  final double spentAmount;
  final List<BudgetMember> members;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final BudgetVisibility visibility;
  final String? inviteCode;
  final bool isActive;

  const SharedBudget({
    required this.id,
    required this.name,
    required this.description,
    required this.totalAmount,
    this.spentAmount = 0.0,
    required this.members,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.periodStart,
    this.periodEnd,
    this.visibility = BudgetVisibility.shared,
    this.inviteCode,
    this.isActive = true,
  });

  double get remainingAmount => totalAmount - spentAmount;
  double get percentageUsed => spentAmount / totalAmount * 100;
  bool get isOverBudget => spentAmount > totalAmount;
  bool get isNearingLimit => percentageUsed >= 80 && !isOverBudget;

  // Get member by user ID
  BudgetMember? getMember(String userId) {
    try {
      return members.firstWhere((m) => m.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Check if user has specific role
  bool hasRole(String userId, BudgetMemberRole role) {
    final member = getMember(userId);
    return member?.role == role;
  }

  // Check if user can perform action
  bool canUserEdit(String userId) {
    final member = getMember(userId);
    return member?.canEdit ?? false;
  }

  bool canUserDelete(String userId) {
    final member = getMember(userId);
    return member?.canDelete ?? false;
  }

  bool canUserInvite(String userId) {
    final member = getMember(userId);
    return member?.canInvite ?? false;
  }

  bool canUserAddExpense(String userId) {
    final member = getMember(userId);
    return member?.canAddExpense ?? false;
  }

  SharedBudget copyWith({
    String? id,
    String? name,
    String? description,
    double? totalAmount,
    double? spentAmount,
    List<BudgetMember>? members,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? periodStart,
    DateTime? periodEnd,
    BudgetVisibility? visibility,
    String? inviteCode,
    bool? isActive,
  }) {
    return SharedBudget(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      members: members ?? this.members,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      visibility: visibility ?? this.visibility,
      inviteCode: inviteCode ?? this.inviteCode,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        totalAmount,
        spentAmount,
        members,
        createdBy,
        createdAt,
        updatedAt,
        periodStart,
        periodEnd,
        visibility,
        inviteCode,
        isActive,
      ];
}
