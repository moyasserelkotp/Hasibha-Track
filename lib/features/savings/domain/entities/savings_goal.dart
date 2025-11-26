import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final String icon; // e.g., 'car', 'house', 'vacation'
  final int color; // Color value
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.icon,
    required this.color,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get remainingAmount => (targetAmount - currentAmount).clamp(0.0, targetAmount);
  bool get isDeadlineApproaching {
    if (deadline == null) return false;
    final daysLeft = deadline!.difference(DateTime.now()).inDays;
    return daysLeft <= 30 && daysLeft > 0;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        currentAmount,
        deadline,
        icon,
        color,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}
