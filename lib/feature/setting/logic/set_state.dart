import '../data/model/settings_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;

  SettingsLoaded(this.settings);
}

class SettingsSaving extends SettingsState {}

class SettingsSaved extends SettingsState {
  final SettingsModel settings;

  SettingsSaved(this.settings);
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}