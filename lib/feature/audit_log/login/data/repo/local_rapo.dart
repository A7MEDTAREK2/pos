import 'package:home/feature/audit_log/login/data/model/audit_log_model.dart';
import '../data_source/local_data_source.dart';

class AuditLogRepositoryImpl {
  final AuditLogLocalDataSource localDataSource;

  AuditLogRepositoryImpl({required this.localDataSource});

  // إضافة سجل مراقبة جديد
  Future<void> addAuditLog(AuditLogModel log) async {
    try {
      await localDataSource.addAuditLog(log);
    } catch (e) {
      throw Exception('Failed to add audit log: $e');
    }
  }

  // جلب كل السجلات مع إمكانية التحديد (Pagination)
  Future<List<AuditLogModel>> getAuditLogs({int? limit, int? offset}) async {
    try {
      return await localDataSource.getAuditLogs(limit: limit, offset: offset);
    } catch (e) {
      throw Exception('Failed to get audit logs: $e');
    }
  }

  // جلب السجلات حسب القسم (Module) مثل المنتجات، المبيعات، الخ
  Future<List<AuditLogModel>> getAuditLogsByModule(String module) async {
    try {
      return await localDataSource.getAuditLogsByModule(module);
    } catch (e) {
      throw Exception('Failed to get audit logs by module: $e');
    }
  }

  // جلب السجلات حسب الكيان المعين (مثل منتج برقم ID معين)
  Future<List<AuditLogModel>> getAuditLogsByEntity(String entityType, String entityId) async {
    try {
      return await localDataSource.getAuditLogsByEntity(entityType, entityId);
    } catch (e) {
      throw Exception('Failed to get audit logs by entity: $e');
    }
  }
}