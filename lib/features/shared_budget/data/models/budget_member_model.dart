import '../../domain/entities/budget_member.dart';

class BudgetMemberModel extends BudgetMember {
  const BudgetMemberModel({
    required super.userId,
    required super.displayName,
    super.email,
    super.photoUrl,
    required super.role,
    required super.joinedAt,
    super.isActive,
  });

  factory BudgetMemberModel.fromJson(Map<String, dynamic> json) {
    return BudgetMemberModel(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      role: _parseRole(json['role'] as String),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  static BudgetMemberRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return BudgetMemberRole.owner;
      case 'admin':
        return BudgetMemberRole.admin;
      case 'member':
        return BudgetMemberRole.member;
      case 'viewer':
        return BudgetMemberRole.viewer;
      default:
        return BudgetMemberRole.member;
    }
  }

  factory BudgetMemberModel.fromEntity(BudgetMember entity) {
    return BudgetMemberModel(
      userId: entity.userId,
      displayName: entity.displayName,
      email: entity.email,
      photoUrl: entity.photoUrl,
      role: entity.role,
      joinedAt: entity.joinedAt,
      isActive: entity.isActive,
    );
  }
}
