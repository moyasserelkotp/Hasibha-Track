class SharedBudgetDto {
  final String id;
  final String name;
  final String description;
  final double totalAmount;
  final double spentAmount;
  final List<Map<String, dynamic>> members;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String? periodStart;
  final String? periodEnd;
  final String visibility;
  final String? inviteCode;
  final bool isActive;

  SharedBudgetDto({
    required this.id,
    required this.name,
    required this.description,
    required this.totalAmount,
    required this.spentAmount,
    required this.members,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.periodStart,
    this.periodEnd,
    required this.visibility,
    this.inviteCode,
    required this.isActive,
  });

  factory SharedBudgetDto.fromJson(Map<String, dynamic> json) {
    return SharedBudgetDto(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      spentAmount: (json['spentAmount'] ?? 0).toDouble(),
      members: (json['members'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] ?? DateTime.now().toIso8601String(),
      periodStart: json['periodStart'],
      periodEnd: json['periodEnd'],
      visibility: json['visibility'] ?? 'shared',
      inviteCode: json['inviteCode'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'totalAmount': totalAmount,
      'spentAmount': spentAmount,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'periodStart': periodStart,
      'periodEnd': periodEnd,
      'visibility': visibility,
      'inviteCode': inviteCode,
      'isActive': isActive,
    };
  }
}

class CreateSharedBudgetDto {
  final String name;
  final String description;
  final double totalAmount;
  final String? periodStart;
  final String? periodEnd;

  CreateSharedBudgetDto({
    required this.name,
    required this.description,
    required this.totalAmount,
    this.periodStart,
    this.periodEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'totalAmount': totalAmount,
      'periodStart': periodStart,
      'periodEnd': periodEnd,
    };
  }
}

class InviteMemberDto {
  final String budgetId;
  final String email;
  final String role;

  InviteMemberDto({
    required this.budgetId,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'email': email,
      'role': role,
    };
  }
}
