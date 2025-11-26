import 'package:equatable/equatable.dart';

/// Category for organizing expenses
class ExpenseCategory extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final String type; // expense or income
  final double? budgetLimit;
  final bool isDefault;
  final DateTime createdAt;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.type,
    this.budgetLimit,
    this.isDefault = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconName,
        colorHex,
        type,
        budgetLimit,
        isDefault,
        createdAt,
      ];

  ExpenseCategory copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    String? type,
    double? budgetLimit,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
