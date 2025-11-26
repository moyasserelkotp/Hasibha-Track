import '../../domain/repositories/settings_repository.dart';
import '../../models/app_settings.dart';
import '../../../features/home/data/datasources/local/home_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final HomeLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettings> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await localDataSource.saveSettings(settings);
  }
}
