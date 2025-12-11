import 'package:equatable/equatable.dart';

enum BudgetMemberRole {
  owner,
  admin,
  member,
  viewer,
}

class BudgetMember extends Equatable {
  final String userId;
  final String displayName;
  final String? email;
  final String? photoUrl;
  final BudgetMemberRole role;
  final DateTime joinedAt;
  final bool isActive;

  const BudgetMember({
    required this.userId,
    required this.displayName,
    this.email,
    this.photoUrl,
    required this.role,
    required this.joinedAt,
    this.isActive = true,
  });

  // Permissions based on role
  bool get canEdit => role == BudgetMemberRole.owner || role == BudgetMemberRole.admin;
  bool get canDelete => role == BudgetMemberRole.owner;
  bool get canInvite => role == BudgetMemberRole.owner || role == BudgetMemberRole.admin;
  bool get canAddExpense => role != BudgetMemberRole.viewer;

  BudgetMember copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    BudgetMemberRole? role,
    DateTime? joinedAt,
    bool? isActive,
  }) {
    return BudgetMember(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        email,
        photoUrl,
        role,
        joinedAt,
        isActive,
      ];
}
