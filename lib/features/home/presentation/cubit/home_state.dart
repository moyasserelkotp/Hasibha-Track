import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_summary.dart';


abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final DashboardSummary dashboardSummary;

  const HomeLoaded({required this.dashboardSummary});
  
  @override
  List<Object?> get props => [dashboardSummary];
}

class HomeError extends HomeState {
  final String message;
  
  const HomeError(this.message);
  
  @override
  List<Object?> get props => [message];
}
