import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/mock_data_provider.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  final bool useMockData;

  HomeCubit({
    required this.getDashboardSummaryUseCase,
    this.useMockData = true, // Default to mock data for testing
  }) : super(const HomeInitial());

  /// Load dashboard - uses mock data if useMockData is true
  void loadDashboard() async {
    emit(const HomeLoading());
    
    if (useMockData) {
      // Use mock data for testing
      await _loadMockData();
    } else {
      // Use real data from API
      loadDashboardData();
    }
  }

  Future<void> _loadMockData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      // Get budget and savings data for stats
      final budgets = MockDataProvider.getMockBudgets();
      final savingsGoals = MockDataProvider.getMockSavingsGoals();
      
      final mockSummary = DashboardSummaryModel(
        totalBalance: MockDataProvider.totalBalance,
        totalIncome: MockDataProvider.monthlyIncome,
        totalExpense: MockDataProvider.monthlyExpenses,
        recentTransactions: MockDataProvider.getRecentTransactions(),
        categoryBreakdown: MockDataProvider.getCategoryBreakdown(),
        userName: MockDataProvider.userName,
        monthlyIncome: MockDataProvider.monthlyIncome,
        monthlyExpenses: MockDataProvider.monthlyExpenses,
        unreadNotifications: 3,
        activeBudgets: budgets.length,
        budgetsOnTrack: budgets.where((b) => !b.isExceeded && !b.isApproachingLimit).length,
        savingsGoals: savingsGoals.length,
        goalsAchieved: savingsGoals.where((g) => g.isCompleted).length,
      );
      
      emit(HomeLoaded(summary: mockSummary));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void loadDashboardData() async {
    emit(const HomeLoading());
    
    final result = await getDashboardSummaryUseCase.call();
    
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (dashboardSummary) => emit(HomeLoaded(summary: dashboardSummary)),
    );
  }

  void refreshDashboard() {
    loadDashboard();
  }
}
