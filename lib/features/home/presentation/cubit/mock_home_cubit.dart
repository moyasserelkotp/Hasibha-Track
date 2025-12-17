import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasibha/features/home/data/models/dashboard_summary_model.dart';
import 'package:hasibha/shared/data/mock_data_provider.dart';
import '../cubit/home_state.dart';

/// Simple mock cubit for testing the modern UI with mock data
class MockHomeCubit extends Cubit<HomeState> {
  MockHomeCubit() : super(const HomeInitial());

  /// Load dashboard with mock data
  void loadDashboard() async {
    emit(const HomeLoading());
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      // Create mock dashboard summary
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
      );
      
      emit(HomeLoaded(summary: mockSummary));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void refreshDashboard() {
    loadDashboard();
  }
}
