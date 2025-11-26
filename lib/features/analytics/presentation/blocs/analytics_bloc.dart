import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_spending_analytics_usecase.dart';
import '../../domain/usecases/get_monthly_comparison_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetSpendingAnalyticsUseCase getSpendingAnalyticsUseCase;
  final GetMonthlyComparisonUseCase getMonthlyComparisonUseCase;

  AnalyticsBloc({
    required this.getSpendingAnalyticsUseCase,
    required this.getMonthlyComparisonUseCase,
  }) : super(const AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<LoadMonthlyComparison>(_onLoadMonthlyComparison);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final analyticsResult = await getSpendingAnalyticsUseCase(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    // Default to current year for monthly comparison if not specified
    final year = event.endDate.year;
    final monthlyResult = await getMonthlyComparisonUseCase(year: year);

    analyticsResult.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (analytics) {
        monthlyResult.fold(
          (failure) => emit(AnalyticsError(failure.message)),
          (monthly) => emit(AnalyticsLoaded(
            analytics: analytics,
            monthlyComparison: monthly,
            filterStartDate: event.startDate,
            filterEndDate: event.endDate,
            filterYear: year,
          )),
        );
      },
    );
  }

  Future<void> _onLoadMonthlyComparison(
    LoadMonthlyComparison event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      
      final result = await getMonthlyComparisonUseCase(year: event.year);

      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (monthly) => emit(currentState.copyWith(
          monthlyComparison: monthly,
          filterYear: event.year,
        )),
      );
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      add(LoadAnalytics(
        startDate: currentState.filterStartDate,
        endDate: currentState.filterEndDate,
      ));
    } else {
      // Default to last 30 days
      final now = DateTime.now();
      add(LoadAnalytics(
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now,
      ));
    }
  }
}
