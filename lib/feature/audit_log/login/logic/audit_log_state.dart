part of 'audit_log_cubit.dart';

abstract class AuditLogState {}

class AuditLogInitial extends AuditLogState {}

class AuditLogLoading extends AuditLogState {}

class AuditLogLoaded extends AuditLogState {
  final List<AuditLogModel> logs;
  AuditLogLoaded(this.logs);
}

class AuditLogDeteleOrError extends AuditLogState {
  final String message;
  AuditLogDeteleOrError(this.message);
}