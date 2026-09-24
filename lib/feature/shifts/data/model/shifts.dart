class ShiftModel {
  final int? id;
  final int userId;
  final String openedAt;
  final String? closedAt;
  final double openingCash;
  final double expectedCash;
  final double? actualCash;
  final double? difference;
  final String status; // 'open' or 'closed'
  final String? closingNote;
  final String createdAt;

  ShiftModel({
    this.id,
    required this.userId,
    required this.openedAt,
    this.closedAt,
    required this.openingCash,
    required this.expectedCash,
    this.actualCash,
    this.difference,
    required this.status,
    this.closingNote,
    required this.createdAt,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    return ShiftModel(
      id: map['id'],
      userId: map['user_id'],
      openedAt: map['opened_at'],
      closedAt: map['closed_at'],
      openingCash: (map['opening_cash'] as num).toDouble(),
      expectedCash: (map['expected_cash'] as num).toDouble(),
      actualCash: map['actual_cash'] != null ? (map['actual_cash'] as num).toDouble() : null,
      difference: map['difference'] != null ? (map['difference'] as num).toDouble() : null,
      status: map['status'] ?? 'open',
      closingNote: map['closing_note'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'opened_at': openedAt,
      'closed_at': closedAt,
      'opening_cash': openingCash,
      'expected_cash': expectedCash,
      'actual_cash': actualCash,
      'difference': difference,
      'status': status,
      'closing_note': closingNote,
      'created_at': createdAt,
    };
  }
}