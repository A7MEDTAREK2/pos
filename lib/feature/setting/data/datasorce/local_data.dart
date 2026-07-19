import 'package:sqflite/sqflite.dart';

import '../../../../../core/data_base/pos_database.dart';
import '../model/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl
    implements SettingsLocalDataSource {
  @override
  Future<SettingsModel> getSettings() async {
    final Database db = await AppDatabase.instance.database;

    final result = await db.query(
      "settings",
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception("Settings not found");
    }

    return SettingsModel.fromMap(result.first);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final Database db = await AppDatabase.instance.database;

    await db.update(
      "settings",
      settings.toMap(),
      where: "id=?",
      whereArgs: [1],
    );
  }
}