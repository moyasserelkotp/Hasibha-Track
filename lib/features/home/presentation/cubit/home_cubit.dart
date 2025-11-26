import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;

  HomeCubit({required this.getDashboardSummaryUseCase}) : super(HomeInitial());

  void loadDashboardData() async {
    emit(HomeLoading());
    
    final result = await getDashboardSummaryUseCase.call();
    
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (dashboardSummary) => emit(HomeLoaded(dashboardSummary: dashboardSummary)),
    );
  }

  void refreshDashboard() {
    loadDashboardData();
  }
}
