import 'package:equatable/equatable.dart';

/// Core expense entity representing a financial transaction
class Expense extends Equatable {
  final String id;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? description;
  final String? note;
  final List<String>? tags;
  final String? attachmentUrl;
  final String? receiptImagePath;
  final String? merchant;
  final bool isRecurring;
  final String? recurringPeriod; // daily, weekly, monthly
  final DateTime createdAt;
  final DateTime updatedAt;

  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.description,
    this.note,
    this.tags,
    this.attachmentUrl,
    this.receiptImagePath,
    this.merchant,
    this.isRecurring = false,
    this.recurringPeriod,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        categoryId,
        date,
        description,
        note,
        tags,
        attachmentUrl,
        receiptImagePath,
        merchant,
        isRecurring,
        recurringPeriod,
        createdAt,
        updatedAt,
      ];

  Expense copyWith({
    String? id,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? description,
    String? note,
    List<String>? tags,
    String? attachmentUrl,
    String? receiptImagePath,
    String? merchant,
    bool? isRecurring,
    String? recurringPeriod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      description: description ?? this.description,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      merchant: merchant ?? this.merchant,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
