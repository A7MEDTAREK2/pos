class CashTransactionModel {
  final int? id;
  final int shiftId;
  final int userId;
  final String type; // 'cash_in' or 'cash_out'
  final double amount;
  final String reason;
  final String createdAt;

  CashTransactionModel({
    this.id,
    required this.shiftId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  factory CashTransactionModel.fromMap(Map<String, dynamic> map) {
    return CashTransactionModel(
      id: map['id'],
      shiftId: map['shift_id'],
      userId: map['user_id'],
      type: map['type'],
      amount: (map['amount'] as num).toDouble(),
      reason: map['reason'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shift_id': shiftId,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'reason': reason,
      'created_at': createdAt,
    };
  }
}