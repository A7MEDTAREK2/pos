class ShiftProduct {
  final String productName;
  final int quantity;
  final double totalSales;

  ShiftProduct({
    required this.productName,
    required this.quantity,
    required this.totalSales,
  });

  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "quantity": quantity,
      "totalSales": totalSales,
    };
  }
}

class ShiftReportRequest {
  final String printerName;
  final int paperWidth;

  final String cashier;

  final String shiftStart;

  final String shiftEnd;

  final int ordersCount;

  final double subtotal;

  final double discount;

  final double tax;

  final double delivery;

  final double netSales;

  final double cash;

  final double visa;

  final double wallet;

  final double other;

  final List<ShiftProduct> products;

  ShiftReportRequest({
    required this.printerName,
    required this.paperWidth,
    required this.cashier,
    required this.shiftStart,
    required this.shiftEnd,
    required this.ordersCount,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.delivery,
    required this.netSales,
    required this.cash,
    required this.visa,
    required this.wallet,
    required this.other,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      "printerName": printerName,
      "paperWidth": paperWidth,
      "cashier": cashier,
      "shiftStart": shiftStart,
      "shiftEnd": shiftEnd,
      "ordersCount": ordersCount,
      "subtotal": subtotal,
      "discount": discount,
      "tax": tax,
      "delivery": delivery,
      "netSales": netSales,
      "cash": cash,
      "visa": visa,
      "wallet": wallet,
      "other": other,
      "products": products.map((e) => e.toJson()).toList(),
    };
  }
}
