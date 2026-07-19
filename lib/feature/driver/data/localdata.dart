import 'package:sqflite/sqflite.dart';
import '../../../core/data_base/pos_database.dart';
import 'model_drive.dart';

class DriverLocalDataSource {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<DriverModel>> getDrivers() async {
    final db = await _db.database;
    final result = await db.query(
      'drivers',
      where: 'is_active = 1',
      orderBy: 'name ASC',
    );
    return result.map((e) => DriverModel.fromMap(e)).toList();
  }

  Future<List<DriverModel>> searchDrivers(String query) async {
    final db = await _db.database;
    final result = await db.query(
      'drivers',
      where: 'name LIKE ? AND is_active = 1',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((e) => DriverModel.fromMap(e)).toList();
  }

  Future<DriverModel?> getDriverById(int id) async {
    final db = await _db.database;
    final result = await db.query(
      'drivers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return DriverModel.fromMap(result.first);
    }
    return null;
  }

  Future<DriverModel?> getDriverByName(String name) async {
    final db = await _db.database;
    final result = await db.query(
      'drivers',
      where: 'name = ? AND is_active = 1',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return DriverModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertDriver(DriverModel driver) async {
    final db = await _db.database;
    await db.insert('drivers', driver.toMap());
  }

  Future<void> updateDriver(DriverModel driver) async {
    final db = await _db.database;
    await db.update(
      'drivers',
      driver.toMap(),
      where: 'id = ?',
      whereArgs: [driver.id],
    );
  }

  Future<void> deleteDriver(int id) async {
    final db = await _db.database;
    await db.delete(
      'drivers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}