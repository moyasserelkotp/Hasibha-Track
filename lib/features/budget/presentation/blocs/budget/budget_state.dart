import 'package:equatable/equatable.dart';
import '../../../domain/entities/budget.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;
  final List<Budget> exceededBudgets;
  final List<Budget> approachingBudgets;

  const BudgetLoaded({
    required this.budgets,
    this.exceededBudgets = const [],
    this.approachingBudgets = const [],
  });

  @override
  List<Object?> get props => [budgets, exceededBudgets, approachingBudgets];

  BudgetLoaded copyWith({
    List<Budget>? budgets,
    List<Budget>? exceededBudgets,
    List<Budget>? approachingBudgets,
  }) {
    return BudgetLoaded(
      budgets: budgets ?? this.budgets,
      exceededBudgets: exceededBudgets ?? this.exceededBudgets,
      approachingBudgets: approachingBudgets ?? this.approachingBudgets,
    );
  }
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

class BudgetOperationSuccess extends BudgetState {
  final String message;

  const BudgetOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
