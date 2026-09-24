class AuditLogModel {
  final int? id;
  final int? userId;
  final String userName;
  final String action;
  final String module;
  final String entityType;
  final String? entityId;
  final String? description;
  final String? newData;
  final String createdAt;

  AuditLogModel({
    this.id,
    this.userId,
    required this.userName,
    required this.action,
    required this.module,
    required this.entityType,
    this.entityId,
    this.description,
    this.newData,
    required this.createdAt,
  });

  factory AuditLogModel.fromMap(Map<String, dynamic> map) {
    return AuditLogModel(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'] ?? '',
      action: map['action'] ?? '',
      module: map['module'] ?? '',
      entityType: map['entity_type'] ?? '',
      entityId: map['entity_id'],
      description: map['description'],
      newData: map['new_data'],
      createdAt: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'action': action,
      'module': module,
      'entity_type': entityType,
      'entity_id': entityId,
      'description': description,
      'new_data': newData,
      'created_at': createdAt,
    };
  }
}