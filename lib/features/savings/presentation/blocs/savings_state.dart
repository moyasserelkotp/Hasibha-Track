import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

abstract class SavingsState extends Equatable {
  const SavingsState();

  @override
  List<Object?> get props => [];
}

class SavingsInitial extends SavingsState {
  const SavingsInitial();
}

class SavingsLoading extends SavingsState {
  const SavingsLoading();
}

class SavingsLoaded extends SavingsState {
  final List<SavingsGoal> goals;

  const SavingsLoaded(this.goals);

  @override
  List<Object?> get props => [goals];

  double get totalSaved => goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  double get totalTarget => goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  double get overallProgress => totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;
}

class SavingsError extends SavingsState {
  final String message;

  const SavingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SavingsOperationSuccess extends SavingsState {
  final String message;

  const SavingsOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
