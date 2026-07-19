import 'package:sqflite/sqflite.dart';

import '../../../data_base/pos_database.dart';
import '../model/print_queue_model.dart';

class PrintQueueLocalDataSource {
  final AppDatabase _db = AppDatabase.instance;

  Future<Database> get database async => await _db.database;

  Future<void> add(PrintQueueModel model) async {
    final db = await database;
    await db.insert(
      "print_queue",
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PrintQueueModel>> pending() async {
    final db = await database;

    final result = await db.query(
      "print_queue",
      where: "status = ?",
      whereArgs: [0],
      orderBy: "id ASC",
    );

    return result.map(PrintQueueModel.fromMap).toList();
  }

  Future<void> markPrinted(int id) async {
    final db = await database;

    await db.update(
      "print_queue",
      {
        "status": 1,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> markFailed(
      int id,
      String error,
      int retryCount,
      ) async {
    final db = await database;

    await db.update(
      "print_queue",
      {
        "status": 0,
        "retry_count": retryCount,
        "last_error": error,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}