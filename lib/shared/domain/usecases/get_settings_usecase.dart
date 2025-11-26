import '../repositories/settings_repository.dart';
import '../../models/app_settings.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase({required this.repository});

  Future<AppSettings> call() async {
    return await repository.getSettings();
  }
}
