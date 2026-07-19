import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/customer_model.dart';

abstract class CustomerAddressLocalDataSource {
  Future<int> addAddress(CustomerAddressModel address);

  Future<void> updateAddress(CustomerAddressModel address);

  Future<void> deleteAddress(int id);

  Future<List<CustomerAddressModel>> getAddresses(int customerId);

  Future<CustomerAddressModel?> getDefaultAddress(int customerId);

  Future<void> setDefaultAddress(int customerId, int addressId);
}

class CustomerAddressLocalDataSourceImpl
    implements CustomerAddressLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<int> addAddress(CustomerAddressModel address) async {
    final db = await _database;

    return await db.insert(
      'customer_addresses',
      address.toMap()..remove('id'),
    );
  }

  @override
  Future<void> updateAddress(CustomerAddressModel address) async {
    final db = await _database;

    await db.update(
      'customer_addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  @override
  Future<void> deleteAddress(int id) async {
    final db = await _database;

    await db.delete(
      'customer_addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CustomerAddressModel>> getAddresses(int customerId) async {
    final db = await _database;

    final result = await db.query(
      'customer_addresses',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'is_default DESC,id DESC',
    );

    return result
        .map((e) => CustomerAddressModel.fromMap(e))
        .toList();
  }

  @override
  Future<CustomerAddressModel?> getDefaultAddress(int customerId) async {
    final db = await _database;

    final result = await db.query(
      'customer_addresses',
      where: 'customer_id = ? AND is_default = 1',
      whereArgs: [customerId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CustomerAddressModel.fromMap(result.first);
  }

  @override
  Future<void> setDefaultAddress(int customerId, int addressId) async {
    final db = await _database;

    await db.transaction((txn) async {
      await txn.update(
        'customer_addresses',
        {'is_default': 0},
        where: 'customer_id = ?',
        whereArgs: [customerId],
      );

      await txn.update(
        'customer_addresses',
        {'is_default': 1},
        where: 'id = ?',
        whereArgs: [addressId],
      );
    });
  }
}