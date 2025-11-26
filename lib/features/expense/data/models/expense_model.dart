import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.categoryId,
    required super.date,
    super.description,
    super.note,
    super.tags,
    super.attachmentUrl,
    super.receiptImagePath,
    super.merchant,
    super.isRecurring,
    super.recurringPeriod,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachmentUrl: json['attachment_url'] as String?,
      receiptImagePath: json['receipt_image_path'] as String?,
      merchant: json['merchant'] as String?,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurringPeriod: json['recurring_period'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'description': description,
      'note': note,
      'tags': tags,
      'attachment_url': attachmentUrl,
      'receipt_image_path': receiptImagePath,
      'merchant': merchant,
      'is_recurring': isRecurring,
      'recurring_period': recurringPeriod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: description,
      note: note,
      tags: tags,
      attachmentUrl: attachmentUrl,
      receiptImagePath: receiptImagePath,
      merchant: merchant,
      isRecurring: isRecurring,
      recurringPeriod: recurringPeriod,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
