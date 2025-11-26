import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_analytics_usecase.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalyticsUseCase getAnalyticsUseCase;

  AnalyticsCubit(this.getAnalyticsUseCase) : super(AnalyticsInitial());

  Future<void> loadAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(AnalyticsLoading());

    final result = await getAnalyticsUseCase(
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (data) => emit(AnalyticsLoaded(data)),
    );
  }

  Future<void> refresh() async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      await loadAnalytics(
        startDate: currentState.data.startDate,
        endDate: currentState.data.endDate,
      );
    } else {
      await loadAnalytics();
    }
  }
}
