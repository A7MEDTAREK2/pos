import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/feature/setting/logic/set_state.dart';

import '../data/model/settings_model.dart';
import '../data/repo/repo.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(SettingsInitial());

  SettingsModel? settings;

  Future<void> loadSettings() async {
    try {
      emit(SettingsLoading());

      settings = await repository.getSettings();

      emit(SettingsLoaded(settings!));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> saveSettings(SettingsModel newSettings) async {
    try {
      emit(SettingsSaving());

      await repository.save(newSettings);

      settings = newSettings;

      emit(SettingsSaved(newSettings));

      emit(SettingsLoaded(newSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> update({
    String? storeName,
    String? phone,
    String? address,
    String? taxNumber,
    String? currency,
    double? taxPercentage,
    String? language,
    String? logo,
    String? cashierPrinter,
    String? kitchenPrinter,
    int? paperWidth,
  }) async {
    if (settings == null) return;

    final updated = settings!.copyWith(
      storeName: storeName,
      phone: phone,
      address: address,
      taxNumber: taxNumber,
      currency: currency,
      taxPercentage: taxPercentage,
      language: language,
      logo: logo,
      cashierPrinter: cashierPrinter,
      kitchenPrinter: kitchenPrinter,
      paperWidth: paperWidth,
    );

    await saveSettings(updated);
  }
}