import '../../core/data_base/pos_database.dart';
import '../../feature/audit_log/login/data/data_source/local_data_source.dart';
import '../../feature/audit_log/login/data/model/audit_log_model.dart';
import '../../feature/audit_log/login/data/repo/local_rapo.dart';

class AuditLogService {
  final AuditLogRepositoryImpl repository;

  AuditLogService(this.repository);

  // Singleton instance جاهزة للاستخدام المباشر
  static final AuditLogService instance = AuditLogService(
    AuditLogRepositoryImpl(
      localDataSource: AuditLogLocalDataSourceImpl(AppDatabase.instance),
    ),
  );

  Future<void> log({
    required int userId,
    required String userName,
    required String action,
    required String module,
    String? entityType,
    String? entityId,
    String? description,
  }) async {
    try {
      final logModel = AuditLogModel(
        id: null, // لكي تتولى SQLite توليد الرقم التسلسلي تلقائياً
        userId: userId,
        userName: userName,
        action: action,
        module: module,
        entityType: entityType ?? '',
        entityId: entityId ?? '',
        description: description ?? '',
        createdAt: DateTime.now(), // إرسال التاريخ والوقت الفعلي كـ DateTime
      );

      await repository.addAuditLog(logModel);
    } catch (e) {
      print("خطأ في تسجيل الـ Audit Log: $e");
    }
  }
}