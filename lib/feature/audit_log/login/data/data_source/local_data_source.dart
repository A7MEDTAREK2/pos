import 'package:sqflite/sqflite.dart';
import '../../../../../core/data_base/pos_database.dart';
import '../model/audit_log_model.dart';

abstract class AuditLogLocalDataSource {
  Future<void> addAuditLog(AuditLogModel log);
  Future<List<AuditLogModel>> getAuditLogs({int? limit, int? offset});
  Future<List<AuditLogModel>> getAuditLogsByModule(String module);
  Future<List<AuditLogModel>> getAuditLogsByEntity(String entityType, String entityId);
}

class AuditLogLocalDataSourceImpl implements AuditLogLocalDataSource {
  final AppDatabase _dbHelper;

  AuditLogLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> addAuditLog(AuditLogModel log) async {
    final db = await _dbHelper.database;
    await db.insert('audit_logs', log.toJson());
  }

  @override
  Future<List<AuditLogModel>> getAuditLogs({int? limit, int? offset}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map((json) => AuditLogModel.fromJson(json)).toList();
  }

  @override
  Future<List<AuditLogModel>> getAuditLogsByModule(String module) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      where: 'module = ?',
      whereArgs: [module],
      orderBy: 'created_at DESC',
    );
    return maps.map((json) => AuditLogModel.fromJson(json)).toList();
  }

  @override
  Future<List<AuditLogModel>> getAuditLogsByEntity(String entityType, String entityId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      where: 'entity_type = ? AND entity_id = ?',
      whereArgs: [entityType, entityId],
      orderBy: 'created_at DESC',
    );
    return maps.map((json) => AuditLogModel.fromJson(json)).toList();
  }
}