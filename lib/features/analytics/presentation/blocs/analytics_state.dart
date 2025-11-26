import 'package:equatable/equatable.dart';
import '../../domain/entities/spending_analytics.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final SpendingAnalytics analytics;
  final List<MonthlySpending> monthlyComparison;
  final DateTime filterStartDate;
  final DateTime filterEndDate;
  final int filterYear;

  const AnalyticsLoaded({
    required this.analytics,
    required this.monthlyComparison,
    required this.filterStartDate,
    required this.filterEndDate,
    required this.filterYear,
  });

  @override
  List<Object?> get props => [
        analytics,
        monthlyComparison,
        filterStartDate,
        filterEndDate,
        filterYear,
      ];

  AnalyticsLoaded copyWith({
    SpendingAnalytics? analytics,
    List<MonthlySpending>? monthlyComparison,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    int? filterYear,
  }) {
    return AnalyticsLoaded(
      analytics: analytics ?? this.analytics,
      monthlyComparison: monthlyComparison ?? this.monthlyComparison,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterYear: filterYear ?? this.filterYear,
    );
  }
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
