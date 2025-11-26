class CreateSavingsGoalDto {
  final String name;
  final double targetAmount;
  final DateTime? deadline;
  final String icon;
  final int color;

  CreateSavingsGoalDto({
    required this.name,
    required this.targetAmount,
    this.deadline,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'target_amount': targetAmount,
      'deadline': deadline?.toIso8601String(),
      'icon': icon,
      'color': color,
    };
  }
}
