import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.categoryId,
    required super.limit,
    required super.period,
    super.spent,
    required super.startDate,
    required super.endDate,
    super.isActive,
    super.alertSettings,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      limit: (json['limit'] as num).toDouble(),
      period: _periodFromString(json['period'] as String),
      spent: json['spent'] != null ? (json['spent'] as num).toDouble() : 0.0,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      alertSettings: json['alert_settings'] != null
          ? _alertSettingsFromJson(json['alert_settings'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'limit': limit,
      'period': _periodToString(period),
      'spent': spent,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'alert_settings': alertSettings != null
          ? _alertSettingsToJson(alertSettings!)
          : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Budget toEntity() {
    return Budget(
      id: id,
      categoryId: categoryId,
      limit: limit,
      period: period,
      spent: spent,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      alertSettings: alertSettings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static BudgetPeriod _periodFromString(String period) {
    switch (period) {
      case 'daily':
        return BudgetPeriod.daily;
      case 'weekly':
        return BudgetPeriod.weekly;
      case 'monthly':
        return BudgetPeriod.monthly;
      case 'yearly':
        return BudgetPeriod.yearly;
      case 'custom':
        return BudgetPeriod.custom;
      default:
        return BudgetPeriod.monthly;
    }
  }

  static String _periodToString(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.daily:
        return 'daily';
      case BudgetPeriod.weekly:
        return 'weekly';
      case BudgetPeriod.monthly:
        return 'monthly';
      case BudgetPeriod.yearly:
        return 'yearly';
      case BudgetPeriod.custom:
        return 'custom';
    }
  }

  static AlertSettings _alertSettingsFromJson(Map<String, dynamic> json) {
    return AlertSettings(
      enabled: json['enabled'] as bool? ?? true,
      threshold: json['threshold'] != null
          ? (json['threshold'] as num).toDouble()
          : 80.0,
      notifyOnExceed: json['notify_on_exceed'] as bool? ?? true,
    );
  }

  static Map<String, dynamic> _alertSettingsToJson(AlertSettings settings) {
    return {
      'enabled': settings.enabled,
      'threshold': settings.threshold,
      'notify_on_exceed': settings.notifyOnExceed,
    };
  }
}
