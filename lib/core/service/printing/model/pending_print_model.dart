class PendingPrintModel {
  final int? id;

  final String type;

  final String data;

  final DateTime createdAt;

  final int status;

  PendingPrintModel({
    this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "data": data,
      "created_at": createdAt.toIso8601String(),
      "status": status,
    };
  }

  factory PendingPrintModel.fromMap(Map<String, dynamic> map) {
    return PendingPrintModel(
      id: map["id"],
      type: map["type"],
      data: map["data"],
      createdAt: DateTime.parse(map["created_at"]),
      status: map["status"],
    );
  }
}