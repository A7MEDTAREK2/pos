// lib/feature/supplier/data/data_source/inventory_local_data_source.dart

import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/supplier_model.dart';

class SupplierLocalDataSource {
  Future<Database> get _db async {
    return AppDatabase.instance.database;
  }

  Future<List<SupplierModel>> getSuppliers() async {
    final db = await _db;

    final result = await db.query(
      'suppliers',
      orderBy: 'id DESC',
    );

    return result
        .map((e) => SupplierModel.fromMap(e))
        .toList();
  }

  Future<List<SupplierModel>> searchSuppliers(String keyword) async {
    final db = await _db;

    final result = await db.query(
      'suppliers',
      where: '''
        name LIKE ?
        OR phone LIKE ?
      ''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'id DESC',
    );

    return result
        .map((e) => SupplierModel.fromMap(e))
        .toList();
  }

  Future<int> insertSupplier(SupplierModel supplier) async {
    final db = await _db;

    return db.insert(
      'suppliers',
      supplier.toMap()..remove('id'),
    );
  }

  Future<int> updateSupplier(SupplierModel supplier) async {
    final db = await _db;

    return db.update(
      'suppliers',
      supplier.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<int> deleteSupplier(int id) async {
    final db = await _db;

    return db.delete(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleSupplierStatus(
      int id,
      bool isActive,
      ) async {
    final db = await _db;

    return db.update(
      'suppliers',
      {
        'is_active': isActive ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}