class ReceiptItem {
  final int productId;
  final String productName;
  final String? sizeName;
  final int quantity;
  final double price;
  final double total;
  final String? note;

  ReceiptItem({
    required this.productId,
    required this.productName,
    this.sizeName,
    required this.quantity,
    required this.price,
    required this.total,
    this.note,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      productId: json["productId"],
      productName: json["productName"],
      sizeName: json["sizeName"],
      quantity: json["quantity"],
      price: (json["price"] as num).toDouble(),
      total: (json["total"] as num).toDouble(),
      note: json["note"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "sizeName": sizeName,
      "quantity": quantity,
      "price": price,
      "total": total,
      "note": note,
    };
  }
}