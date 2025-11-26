import '../../domain/entities/expense_category.dart';

class ExpenseCategoryModel extends ExpenseCategory {
  const ExpenseCategoryModel({
    required super.id,
    required super.name,
    required super.iconName,
    required super.colorHex,
    required super.type,
    super.budgetLimit,
    super.isDefault,
    required super.createdAt,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      type: json['type'] as String,
      budgetLimit: json['budget_limit'] != null
          ? (json['budget_limit'] as num).toDouble()
          : null,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
      'type': type,
      'budget_limit': budgetLimit,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ExpenseCategory toEntity() {
    return ExpenseCategory(
      id: id,
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      type: type,
      budgetLimit: budgetLimit,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}
