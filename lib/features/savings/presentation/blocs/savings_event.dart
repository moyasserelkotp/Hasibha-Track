import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavingsGoals extends SavingsEvent {
  const LoadSavingsGoals();
}

class CreateSavingsGoal extends SavingsEvent {
  final SavingsGoal goal;

  const CreateSavingsGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class UpdateSavingsGoal extends SavingsEvent {
  final SavingsGoal goal;

  const UpdateSavingsGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DeleteSavingsGoal extends SavingsEvent {
  final String id;

  const DeleteSavingsGoal(this.id);

  @override
  List<Object?> get props => [id];
}

class AddFundsToGoal extends SavingsEvent {
  final String id;
  final double amount;

  const AddFundsToGoal({required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}

class WithdrawFundsFromGoal extends SavingsEvent {
  final String id;
  final double amount;

  const WithdrawFundsFromGoal({required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}
