import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final List<String>? tags;

  const LoadExpenses({
    this.startDate,
    this.endDate,
    this.categoryId,
    this.tags,
  });

  @override
  List<Object?> get props => [startDate, endDate, categoryId, tags];
}

class RefreshExpenses extends ExpenseEvent {
  const RefreshExpenses();
}

class CreateExpense extends ExpenseEvent {
  final Expense expense;

  const CreateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;

  const DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

class ImportExpenseFromImage extends ExpenseEvent {
  final String imagePath;

  const ImportExpenseFromImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class FilterExpensesByCategory extends ExpenseEvent {
  final String? categoryId;

  const FilterExpensesByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class FilterExpensesByDateRange extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterExpensesByDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
