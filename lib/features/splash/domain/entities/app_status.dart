import 'package:equatable/equatable.dart';

class AppStatus extends Equatable {
  final bool hasCompletedOnboarding;
  final bool isAuthenticated;
  final String nextRoute;

  const AppStatus({
    required this.hasCompletedOnboarding,
    required this.isAuthenticated,
    required this.nextRoute,
  });

  @override
  List<Object?> get props => [
        hasCompletedOnboarding,
        isAuthenticated,
        nextRoute,
      ];
}
