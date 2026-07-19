import '../../../../feature/cashier/data/model/pos_model.dart';

class ReceiptMapper {
  static Map<String, dynamic> fromOrder({
    required OrderModel order,
    required String printerName,
    int paperWidth = 80,
  }) {
    return {
      "printerName": printerName,

      // 58 أو 80 حسب الـ API عندك
      "paperWidth": paperWidth == 58 ? 0 : 1,

      // بيانات المحل (هنجيبها من Settings بعدين)
      "storeName": "Modu POS",
      "storePhone": "",
      "storeAddress": "",
      "taxNumber": "",

      "invoiceNumber": order.orderNumber,
      "date": DateTime.now().toIso8601String(),

      "cashier": "Cashier",

      "customerName": order.customerName ?? "",
      "customerPhone": order.customerPhone ?? "",

      "orderType": order.orderType.name,
      "paymentMethod": order.paymentMethod ?? "Cash",

      "products": order.items.map((item) {
        return {
          "productName": item["name"] ?? "",
          "sizeName": item["size"] ?? "",
          "quantity": item["quantity"] ?? 1,
          "price": (item["price"] as num).toDouble(),
          "total":
          ((item["price"] as num).toDouble()) *
              ((item["quantity"] as int)),
          "note": item["note"] ?? "",
        };
      }).toList(),

      "subTotal": order.subtotal ?? order.totalAmount,
      "discount": order.discount ?? 0,
      "tax": order.tax ?? 0,
      "delivery": order.deliveryFee ?? 0,
      "grandTotal": order.totalAmount,

      "qrCodeData": "",
      "footer": "Thank You ❤",
    };
  }
}