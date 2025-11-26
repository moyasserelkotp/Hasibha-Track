class BudgetDto {
  final String categoryId;
  final double limit;
  final String period; // daily, weekly, monthly, yearly, custom
  final String startDate; // ISO 8601 format
  final String endDate; // ISO 8601 format
  final bool? isActive;
  final Map<String, dynamic>? alertSettings;

  BudgetDto({
    required this.categoryId,
    required this.limit,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.isActive,
    this.alertSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'limit': limit,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (alertSettings != null) 'alert_settings': alertSettings,
    };
  }
}
