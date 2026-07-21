import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';

class MaintenanceLocalDataSource {
  final AppDatabase database;

  MaintenanceLocalDataSource(this.database);

  //==============================
  // Backup Database
  //==============================

  Future<String> backupDatabase() async {
    final db = await database.database;

    final dbPath = db.path;

    final result = await FilePicker.platform.saveFile(
      dialogTitle: "Backup Database",
      fileName:
      "modu_backup_${DateTime.now().millisecondsSinceEpoch}.db",
    );

    if (result == null) {
      throw Exception("Backup cancelled");
    }

    await db.close();

    await File(dbPath).copy(result);

    return result;
  }

  //==============================
  // Restore Database
  //==============================

  Future<void> restoreDatabase() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["db"],
    );

    if (file == null) return;

    final db = await database.database;

    final currentPath = db.path;

    await db.close();

    await File(file.files.single.path!).copy(currentPath);
  }

  //==============================
  // Delete Sales
  //==============================

  Future<void> deleteSales() async {
    final db = await database.database;

    await db.transaction((txn) async {
      await txn.delete("sale_items");
      await txn.delete("sales");

      await txn.delete("holding_order_items");
      await txn.delete("holding_orders");

      await txn.delete("print_queue");

      await txn.delete("shift_session");

      await txn.insert("shift_session", {
        "id": 1,
        "shift_start": DateTime.now().toIso8601String(),
        "order_counter": 1,
      });
    });
  }

  //==============================
  // Delete Customers
  //==============================

  Future<void> deleteCustomers() async {
    final db = await database.database;

    await db.transaction((txn) async {
      await txn.delete("customer_addresses");
      await txn.delete("customers");
    });
  }

  //==============================
  // Delete All Data
  //==============================

  Future<void> deleteAllData() async {
    final db = await database.database;

    await db.transaction((txn) async {
      await txn.delete("sale_items");
      await txn.delete("sales");

      await txn.delete("holding_order_items");
      await txn.delete("holding_orders");

      await txn.delete("customer_addresses");
      await txn.delete("customers");

      await txn.delete("product_sizes");
      await txn.delete("products");
      await txn.delete("categories");

      await txn.delete("drivers");

      await txn.delete("print_queue");

      await txn.delete("shift_session");

      await txn.insert("shift_session", {
        "id": 1,
        "shift_start": DateTime.now().toIso8601String(),
        "order_counter": 1,
      });
    });
  }

  //==============================
  // Restart Shift
  //==============================

  Future<void> restartShift() async {
    final db = await database.database;

    await db.delete("shift_session");

    await db.insert(
      "shift_session",
      {
        "id": 1,
        "shift_start": DateTime.now().toIso8601String(),
        "order_counter": 1,
      },
    );
  }

  //==============================
  // Exit App
  //==============================

  Future<void> closeDatabase() async {
    await database.close();
  }
}