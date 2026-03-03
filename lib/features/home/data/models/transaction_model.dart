import 'package:hive/hive.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends Transaction {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final double amount;

  @override
  @HiveField(3)
  final String category;

  @override
  @HiveField(4)
  final String type;

  @override
  @HiveField(5)
  final DateTime date;

  @override
  @HiveField(6)
  final String? description;

  @override
  @HiveField(7)
  final String? icon;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.description,
    this.icon,
  }) : super(
          id: id,
          title: title,
          amount: amount,
          category: category,
          type: type,
          date: date,
          description: description,
          icon: icon,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Support both legacy and new backend shapes.
    // New backend transaction:
    // {
    //   "_id": "...",
    //   "type": "income" | "expense",
    //   "amount": 150.5,
    //   "category": "Food & Dining",
    //   "description": "Grocery shopping",
    //   "date": "2026-02-25T00:00:00.000Z",
    //   "paymentMethod": "cash",
    //   "tags": [...],
    //   "notes": "..."
    // }
    final id = (json['id'] ?? json['_id'] ?? '') as String;
    final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
    final category = (json['category'] as String?) ?? 'Uncategorized';
    final type = (json['type'] as String?) ?? 'expense';
    final dateString = (json['date'] as String?) ?? DateTime.now().toIso8601String();
    final description = (json['description'] ?? json['notes']) as String?;

    // Derive a reasonable title if not present
    final title = (json['title'] as String?) ??
        (description?.isNotEmpty == true
            ? description!
            : category);

    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      category: category,
      type: type,
      date: DateTime.parse(dateString),
      description: description,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date.toIso8601String(),
      'description': description,
      'icon': icon,
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      category: transaction.category,
      type: transaction.type,
      date: transaction.date,
      description: transaction.description,
      icon: transaction.icon,
    );
  }
}
