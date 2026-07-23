import 'package:sqflite/sqflite.dart';

import '../../../../../core/data_base/pos_database.dart';
import '../model/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<SettingsModel> getSettings() async {
    final Database db = await AppDatabase.instance.database;

    final result = await db.query(
      "settings",
      limit: 1,
    );

    // لو الجدول فاضي، ننشئ سجل افتراضي ونحفظه بـ id = 1 فوراً
    if (result.isEmpty) {
      final defaultSettings = SettingsModel.defaultSettings();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }

    return SettingsModel.fromMap(result.first);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final Database db = await AppDatabase.instance.database;

    final map = settings.toMap();
    map['id'] = 1; // التأكد دائمًا أن السجل المحفوظ يحمل id = 1

    // insert مع ConflictAlgorithm.replace هيحدث البيانات لو الـ id موجود، أو ينشئه لو مش موجود
    await db.insert(
      "settings",
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}