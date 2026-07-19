import '../datasorce/local_data.dart';
import '../model/settings_model.dart';

class SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepository(this.localDataSource);

  Future<SettingsModel> getSettings() {
    return localDataSource.getSettings();
  }

  Future<void> save(SettingsModel settings) {
    return localDataSource.saveSettings(settings);
  }
}