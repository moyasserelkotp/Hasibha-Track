import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final String? description;
  final String? icon;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.description,
    this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        category,
        type,
        date,
        description,
        icon,
      ];
}
