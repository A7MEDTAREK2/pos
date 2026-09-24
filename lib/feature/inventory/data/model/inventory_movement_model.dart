class InventoryMovementModel {
  final int? id;
  final int productId;
  final String? productName;
  final String productType;
  final double quantity;
  final String movementType; // 'in', 'out', 'adjustment'
  final String reason;       // 'purchase', 'sale', 'damage', 'manual'
  final int? referenceId;
  final String? referenceType;
  final String? note;
  final int? userId;
  final DateTime createdAt;

  InventoryMovementModel({
    this.id,
    required this.productId,
    this.productName,
    this.productType = 'product',
    required this.quantity,
    required this.movementType,
    required this.reason,
    this.referenceId,
    this.referenceType,
    this.note,
    this.userId,
    required this.createdAt,
  });

  factory InventoryMovementModel.fromMap(Map<String, dynamic> map) {
    return InventoryMovementModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String?,
      productType: map['product_type'] as String? ?? 'product',
      quantity: (map['quantity'] as num).toDouble(),
      movementType: map['movement_type'] as String,
      reason: map['reason'] as String,
      referenceId: map['reference_id'] as int?,
      referenceType: map['reference_type'] as String?,
      note: map['note'] as String?,
      userId: map['user_id'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'product_type': productType,
      'quantity': quantity,
      'movement_type': movementType,
      'reason': reason,
      'reference_id': referenceId,
      'reference_type': referenceType,
      'note': note,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}