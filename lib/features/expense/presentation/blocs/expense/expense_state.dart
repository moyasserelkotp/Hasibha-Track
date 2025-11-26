import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterCategoryId;

  const ExpenseLoaded({
    required this.expenses,
    this.filterStartDate,
    this.filterEndDate,
    this.filterCategoryId,
  });

  @override
  List<Object?> get props => [
        expenses,
        filterStartDate,
        filterEndDate,
        filterCategoryId,
      ];

  ExpenseLoaded copyWith({
    List<Expense>? expenses,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterCategoryId,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterCategoryId: filterCategoryId ?? this.filterCategoryId,
    );
  }
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseOperationSuccess extends ExpenseState {
  final String message;
  final List<Expense> expenses;

  const ExpenseOperationSuccess({
    required this.message,
    required this.expenses,
  });

  @override
  List<Object?> get props => [message, expenses];
}

class ExpenseImporting extends ExpenseState {
  const ExpenseImporting();
}

class ExpenseImported extends ExpenseState {
  final Expense expense;

  const ExpenseImported(this.expense);

  @override
  List<Object?> get props => [expense];
}
