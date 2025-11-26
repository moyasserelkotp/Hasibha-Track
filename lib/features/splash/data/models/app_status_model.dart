import '../../domain/entities/app_status.dart';


class AppStatusModel extends AppStatus {
  const AppStatusModel({
    required super.hasCompletedOnboarding,
    required super.isAuthenticated,
    required super.nextRoute,
  });

  factory AppStatusModel.fromEntity(AppStatus entity) {
    return AppStatusModel(
      hasCompletedOnboarding: entity.hasCompletedOnboarding,
      isAuthenticated: entity.isAuthenticated,
      nextRoute: entity.nextRoute,
    );
  }
}
