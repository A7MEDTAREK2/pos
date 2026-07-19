class KitchenItem {
  final String productName;
  final String? sizeName;
  final int quantity;
  final String? note;

  KitchenItem({
    required this.productName,
    this.sizeName,
    required this.quantity,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "sizeName": sizeName,
      "quantity": quantity,
      "note": note,
    };
  }
}

class KitchenRequest {
  final String printerName;

  final int paperWidth;

  final String orderType;

  final String tableNumber;

  final String customerName;

  final String deliveryAddress;

  final List<KitchenItem> items;

  KitchenRequest({
    required this.printerName,
    required this.paperWidth,
    required this.orderType,
    required this.tableNumber,
    required this.customerName,
    required this.deliveryAddress,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "printerName": printerName,
      "paperWidth": paperWidth,
      "orderType": orderType,
      "tableNumber": tableNumber,
      "customerName": customerName,
      "deliveryAddress": deliveryAddress,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}