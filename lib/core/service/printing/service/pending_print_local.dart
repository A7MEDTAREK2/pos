import 'package:sqflite/sqflite.dart';

import '../../../data_base/pos_database.dart';
import '../model/pending_print_model.dart';

class PendingPrintLocal {

  final AppDatabase db;

  PendingPrintLocal(this.db);

  Future<void> insert(PendingPrintModel model) async {

    final database = await db.database;

    await database.insert(
      "pending_prints",
      model.toMap(),
    );
  }

  Future<List<PendingPrintModel>> getPending() async {

    final database = await db.database;

    final result = await database.query(
      "pending_prints",
      where: "status = 0",
    );

    return result
        .map((e) => PendingPrintModel.fromMap(e))
        .toList();
  }

  Future<void> markPrinted(int id) async {

    final database = await db.database;

    await database.update(
      "pending_prints",
      {
        "status":1,
      },
      where: "id=?",
      whereArgs: [id],
    );
  }
}