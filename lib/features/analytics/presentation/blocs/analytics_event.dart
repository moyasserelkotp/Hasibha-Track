import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadAnalytics({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadMonthlyComparison extends AnalyticsEvent {
  final int year;

  const LoadMonthlyComparison({required this.year});

  @override
  List<Object?> get props => [year];
}

class RefreshAnalytics extends AnalyticsEvent {
  const RefreshAnalytics();
}
