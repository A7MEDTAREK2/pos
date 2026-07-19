import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<int> addCustomer(CustomerModel customer);

  Future<void> updateCustomer(CustomerModel customer);

  Future<void> deleteCustomer(int id);

  Future<List<CustomerModel>> getCustomers();

  Future<List<CustomerModel>> searchCustomers(String keyword);

  Future<CustomerModel?> getCustomerByPhone(String phone);

  Future<CustomerModel?> getCustomerById(int id);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<int> addCustomer(CustomerModel customer) async {
    final db = await _database;

    return await db.insert(
      'customers',
      customer.toMap()..remove('id'),
    );
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) async {
    final db = await _database;

    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  @override
  Future<void> deleteCustomer(int id) async {
    final db = await _database;

    await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final db = await _database;

    final result = await db.query(
      'customers',
      orderBy: 'name ASC',
    );

    return result
        .map((e) => CustomerModel.fromMap(e))
        .toList();
  }

  @override
  Future<List<CustomerModel>> searchCustomers(String keyword) async {
    final db = await _database;

    final result = await db.query(
      'customers',
      where: '''
       name LIKE ?
       OR phone LIKE ?
          ''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'name ASC',
    );

    return result
        .map((e) => CustomerModel.fromMap(e))
        .toList();
  }

  @override
  Future<CustomerModel?> getCustomerByPhone(String phone) async {
    final db = await _database;

    final result = await db.query(
      'customers',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CustomerModel.fromMap(result.first);
  }

  @override
  Future<CustomerModel?> getCustomerById(int id) async {
    final db = await _database;

    final result = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CustomerModel.fromMap(result.first);
  }

}