import '../repositories/settings_repository.dart';
import '../../models/app_settings.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase({required this.repository});

  Future<void> call(AppSettings settings) async {
    await repository.saveSettings(settings);
  }
}
