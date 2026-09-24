// مسار الملف الخاص بـ AuditLogModel
import 'dart:convert';

class AuditLogModel {
  final int? id;
  final int? userId;
  final String userName;
  final String action;
  final String module;
  final String entityType;
  final String? entityId;
  final String? referenceType;
  final String? referenceId;
  final String? description;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final Map<String, dynamic>? changeData;
  final num? quantityBefore;
  final num? quantityChange;
  final num? quantityAfter;
  final String? movementType;
  final String? reason;
  final DateTime createdAt;

  AuditLogModel({
    this.id,
    this.userId,
    required this.userName,
    required this.action,
    required this.module,
    required this.entityType,
    this.entityId,
    this.referenceType,
    this.referenceId,
    this.description,
    this.oldData,
    this.newData,
    this.changeData,
    this.quantityBefore,
    this.quantityChange,
    this.quantityAfter,
    this.movementType,
    this.reason,
    required this.createdAt,
  });

  // توافقاً مع toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'action': action,
      'module': module,
      'entity_type': entityType,
      'entity_id': entityId,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'description': description,
      'old_data': oldData != null ? jsonEncode(oldData) : null,
      'new_data': newData != null ? jsonEncode(newData) : null,
      'change_data': changeData != null ? jsonEncode(changeData) : null,
      'quantity_before': quantityBefore,
      'quantity_change': quantityChange,
      'quantity_after': quantityAfter,
      'movement_type': movementType,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // توافقاً مع fromJson
  factory AuditLogModel.fromJson(Map<String, dynamic> map) {
    return AuditLogModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      userName: map['user_name'] ?? 'مستخدم غير معروف',
      action: map['action'] ?? '',
      module: map['module'] ?? '',
      entityType: map['entity_type'] ?? '',
      entityId: map['entity_id']?.toString(),
      referenceType: map['reference_type'],
      referenceId: map['reference_id']?.toString(),
      description: map['description'],
      oldData: map['old_data'] != null ? jsonDecode(map['old_data']) : null,
      newData: map['new_data'] != null ? jsonDecode(map['new_data']) : null,
      changeData: map['change_data'] != null ? jsonDecode(map['change_data']) : null,
      quantityBefore: map['quantity_before'],
      quantityChange: map['quantity_change'],
      quantityAfter: map['quantity_after'],
      movementType: map['movement_type'],
      reason: map['reason'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // التحويل من Entity (لو أردت استخدام Entities لاحقاً) أو يمكنك جعل الـ DataSource يتعامل مع الـ Model مباشرة لتجنب التعقيد
  factory AuditLogModel.fromEntity(dynamic entity) {
    return AuditLogModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      action: entity.action,
      module: entity.module,
      entityType: entity.entityType,
      entityId: entity.entityId,
      referenceType: entity.referenceType,
      referenceId: entity.referenceId,
      description: entity.description,
      oldData: entity.oldData,
      newData: entity.newData,
      changeData: entity.changeData,
      quantityBefore: entity.quantityBefore,
      quantityChange: entity.quantityChange,
      quantityAfter: entity.quantityAfter,
      movementType: entity.movementType,
      reason: entity.reason,
      createdAt: entity.createdAt,
    );
  }
}