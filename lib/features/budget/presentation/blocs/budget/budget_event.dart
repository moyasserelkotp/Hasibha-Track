import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgets extends BudgetEvent {
  final bool? isActive;
  final String? categoryId;

  const LoadBudgets({this.isActive, this.categoryId});

  @override
  List<Object?> get props => [isActive, categoryId];
}

class RefreshBudgets extends BudgetEvent {
  const RefreshBudgets();
}

class CreateBudget extends BudgetEvent {
  final Budget budget;

  const CreateBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class UpdateBudget extends BudgetEvent {
  final Budget budget;

  const UpdateBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class DeleteBudget extends BudgetEvent {
  final String id;

  const DeleteBudget(this.id);

  @override
  List<Object?> get props => [id];
}

class CheckBudgetLimits extends BudgetEvent {
  const CheckBudgetLimits();
}
