import 'package:equatable/equatable.dart';

enum ExpenseType {
  expense,
  income,
  transfer,
}

class SharedExpense extends Equatable {
  final String id;
  final String budgetId;
  final String category;
  final String description;
  final double amount;
  final ExpenseType type;
  final String addedBy;
  final String addedByName;
  final DateTime date;
  final DateTime createdAt;
  final String? note;
  final String? receiptUrl;
  final List<String>? tags;
  final Map<String, double>? splitAmounts; // userId -> amount they owe
  final bool isSplit;

  const SharedExpense({
    required this.id,
    required this.budgetId,
    required this.category,
    required this.description,
    required this.amount,
    this.type = ExpenseType.expense,
    required this.addedBy,
    required this.addedByName,
    required this.date,
    required this.createdAt,
    this.note,
    this.receiptUrl,
    this.tags,
    this.splitAmounts,
    this.isSplit = false,
  });

  SharedExpense copyWith({
    String? id,
    String? budgetId,
    String? category,
    String? description,
    double? amount,
    ExpenseType? type,
    String? addedBy,
    String? addedByName,
    DateTime? date,
    DateTime? createdAt,
    String? note,
    String? receiptUrl,
    List<String>? tags,
    Map<String, double>? splitAmounts,
    bool? isSplit,
  }) {
    return SharedExpense(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      addedBy: addedBy ?? this.addedBy,
      addedByName: addedByName ?? this.addedByName,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      tags: tags ?? this.tags,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      isSplit: isSplit ?? this.isSplit,
    );
  }

  @override
  List<Object?> get props => [
        id,
        budgetId,
        category,
        description,
        amount,
        type,
        addedBy,
        addedByName,
        date,
        createdAt,
        note,
        receiptUrl,
        tags,
        splitAmounts,
        isSplit,
      ];
}
