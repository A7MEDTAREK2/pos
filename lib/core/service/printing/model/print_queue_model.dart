class PrintQueueModel {
  final int? id;
  final String type;
  final String payload;
  final int status;
  final int retryCount;
  final String createdAt;
  final String? lastError;

  const PrintQueueModel({
    this.id,
    required this.type,
    required this.payload,
    this.status = 0,
    this.retryCount = 0,
    required this.createdAt,
    this.lastError,
  });

  factory PrintQueueModel.fromMap(Map<String, dynamic> map) {
    return PrintQueueModel(
      id: map["id"],
      type: map["type"],
      payload: map["payload"],
      status: map["status"],
      retryCount: map["retry_count"],
      createdAt: map["created_at"],
      lastError: map["last_error"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "payload": payload,
      "status": status,
      "retry_count": retryCount,
      "created_at": createdAt,
      "last_error": lastError,
    };
  }
}