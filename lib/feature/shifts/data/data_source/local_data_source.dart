

import 'dart:convert';

import '../../../../core/data_base/pos_database.dart';
import '../../../audit_log/login/data/model/audit_log_model.dart';
import '../model/CashTransactionModel.dart';
import '../model/shifts.dart';

abstract class ShiftsLocalDataSource {
  Future<ShiftModel?> getCurrentActiveShift();
  Future<int> openShift({required int userId, required double openingCash});
  Future<void> addCashTransaction(CashTransactionModel transaction);
  Future<List<CashTransactionModel>> getShiftTransactions(int shiftId);
  Future<void> closeShift({
    required int shiftId,
    required double actualCash,
    required double expectedCash,
    required String? closingNote,
    required int userId,
    required String userName,
  });
  Future<List<AuditLogModel>> getAuditLogs();
  Future<void> addAuditLog(AuditLogModel log);
}

class ShiftsLocalDataSourceImpl implements ShiftsLocalDataSource {
  final AppDatabase appDatabase;

  ShiftsLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<ShiftModel?> getCurrentActiveShift() async {
    final db = await appDatabase.database;
    final result = await db.query(
      'shifts',
      where: "status = ?",
      whereArgs: ['open'],
      orderBy: "id DESC",
      limit: 1,
    );

    if (result.isEmpty) return null;
    return ShiftModel.fromMap(result.first);
  }

  @override
  Future<int> openShift({required int userId, required double openingCash}) async {
    final db = await appDatabase.database;
    final now = DateTime.now().toIso8601String();

    final activeShift = await getCurrentActiveShift();
    if (activeShift != null) {
      throw Exception('توجد وردية مفتوحة بالفعل!');
    }

    int shiftId = 0;
    await db.transaction((txn) async {
      shiftId = await txn.insert('shifts', {
        'user_id': userId,
        'opened_at': now,
        'opening_cash': openingCash,
        'expected_cash': openingCash,
        'status': 'open',
        'created_at': now,
      });

      await txn.insert('cash_transactions', {
        'shift_id': shiftId,
        'user_id': userId,
        'type': 'cash_in',
        'amount': openingCash,
        'reason': 'رصيد فتح الوردية (Opening Cash)',
        'created_at': now,
      });
    });

    return shiftId;
  }

  @override
  Future<void> addCashTransaction(CashTransactionModel transaction) async {
    final db = await appDatabase.database;

    await db.transaction((txn) async {
      await txn.insert('cash_transactions', transaction.toMap());

      final shiftResult = await txn.query(
        'shifts',
        where: 'id = ?',
        whereArgs: [transaction.shiftId],
      );

      if (shiftResult.isNotEmpty) {
        double currentExpected = (shiftResult.first['expected_cash'] as num).toDouble();
        double newExpected = transaction.type == 'cash_in'
            ? currentExpected + transaction.amount
            : currentExpected - transaction.amount;

        await txn.update(
          'shifts',
          {'expected_cash': newExpected},
          where: 'id = ?',
          whereArgs: [transaction.shiftId],
        );
      }
    });
  }

  @override
  Future<List<CashTransactionModel>> getShiftTransactions(int shiftId) async {
    final db = await appDatabase.database;
    final result = await db.query(
      'cash_transactions',
      where: 'shift_id = ?',
      whereArgs: [shiftId],
      orderBy: 'id DESC',
    );

    return result.map((map) => CashTransactionModel.fromMap(map)).toList();
  }

  @override
  Future<void> closeShift({
    required int shiftId,
    required double actualCash,
    required double expectedCash,
    required String? closingNote,
    required int userId,
    required String userName,
  }) async {
    final db = await appDatabase.database;
    final now = DateTime.now().toIso8601String();
    final difference = actualCash - expectedCash;

    await db.transaction((txn) async {
      await txn.update(
        'shifts',
        {
          'closed_at': now,
          'actual_cash': actualCash,
          'difference': difference,
          'status': 'closed',
          'closing_note': closingNote,
        },
        where: 'id = ?',
        whereArgs: [shiftId],
      );

      await txn.insert('audit_logs', {
        'user_id': userId,
        'user_name': userName,
        'action': 'CLOSE_SHIFT',
        'module': 'Shifts',
        'entity_type': 'shift',
        'entity_id': shiftId.toString(),
        'description': 'تم إغلاق الوردية رقم $shiftId. الفعلي: $actualCash, المتوقع: $expectedCash, الفارق: $difference',
        'new_data': jsonEncode({
          'actual_cash': actualCash,
          'expected_cash': expectedCash,
          'difference': difference,
          'closing_note': closingNote,
        }),
        'created_at': now,
      });
    });
  }

  @override
  Future<List<AuditLogModel>> getAuditLogs() async {
    final db = await appDatabase.database;
    final result = await db.query('audit_logs', orderBy: 'id DESC');
    return result.map((map) => AuditLogModel.fromJson(map)).toList();
  }

  @override
  Future<void> addAuditLog(AuditLogModel log) async {
    final db = await appDatabase.database;
    await db.insert('audit_logs', log.toJson());
  }
}