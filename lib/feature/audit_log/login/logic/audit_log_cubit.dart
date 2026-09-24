import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/audit_log_model.dart';
import '../data/repo/local_rapo.dart';

part 'audit_log_state.dart';

class AuditLogCubit extends Cubit<AuditLogState> {
  final AuditLogRepositoryImpl repository;

  AuditLogCubit(this.repository) : super(AuditLogInitial());

  // جلب كل السجلات
  Future<void> fetchAuditLogs({int? limit, int? offset}) async {
    emit(AuditLogLoading());
    try {
      final logs = await repository.getAuditLogs(limit: limit, offset: offset);
      emit(AuditLogLoaded(logs));
    } catch (e) {
      emit(AuditLogDeteleOrError(e.toString()));
    }
  }

  // جلب السجلات حسب القسم (Module)
  Future<void> fetchLogsByModule(String module) async {
    emit(AuditLogLoading());
    try {
      final logs = await repository.getAuditLogsByModule(module);
      emit(AuditLogLoaded(logs));
    } catch (e) {
      emit(AuditLogDeteleOrError(e.toString()));
    }
  }

  // إضافة سجل جديد
  Future<void> addNewLog(AuditLogModel log) async {
    try {
      await repository.addAuditLog(log);
      // بعد الإضافة يمكنك إعادة جلب السجلات لتحديث الشاشة تلقائياً
      fetchAuditLogs();
    } catch (e) {
      emit(AuditLogDeteleOrError(e.toString()));
    }
  }
}