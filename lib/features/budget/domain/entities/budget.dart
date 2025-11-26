import 'package:equatable/equatable.dart';

/// Budget entity for setting spending limits per category
class Budget extends Equatable {
  final String id;
  final String categoryId;
  final double limit;
  final BudgetPeriod period;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final AlertSettings? alertSettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.period,
    this.spent = 0.0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.alertSettings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate percentage spent
  double get percentageSpent => limit > 0 ? (spent / limit) * 100 : 0;

  /// Check if budget is exceeded
  bool get isExceeded => spent > limit;

  /// Check if approaching limit (>= 80%)
  bool get isApproachingLimit => percentageSpent >= 80;

  /// Get remaining amount
  double get remaining => limit - spent;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        limit,
        period,
        spent,
        startDate,
        endDate,
        isActive,
        alertSettings,
        createdAt,
        updatedAt,
      ];

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limit,
    BudgetPeriod? period,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    AlertSettings? alertSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      period: period ?? this.period,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      alertSettings: alertSettings ?? this.alertSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Budget period enum
enum BudgetPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

/// Alert settings for budget
class AlertSettings extends Equatable {
  final bool enabled;
  final double threshold; // Percentage (e.g., 80 for 80%)
  final bool notifyOnExceed;

  const AlertSettings({
    this.enabled = true,
    this.threshold = 80.0,
    this.notifyOnExceed = true,
  });

  @override
  List<Object?> get props => [enabled, threshold, notifyOnExceed];

  AlertSettings copyWith({
    bool? enabled,
    double? threshold,
    bool? notifyOnExceed,
  }) {
    return AlertSettings(
      enabled: enabled ?? this.enabled,
      threshold: threshold ?? this.threshold,
      notifyOnExceed: notifyOnExceed ?? this.notifyOnExceed,
    );
  }
}
