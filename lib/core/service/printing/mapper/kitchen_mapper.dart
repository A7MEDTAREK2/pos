import '../../../../feature/cashier/data/model/pos_model.dart';

class KitchenReceiptMapper {
  static Map<String, dynamic> fromOrder({
    required OrderModel order,
    required String printerName,
    required String department, // اسم القسم (مثل: مطبخ، بار، مشاوي)
    int paperWidth = 80,
    Map<String, dynamic>? formattingSettings, // إعدادات الـ Bold والتنسيق القادمة من شاشة الإعدادات
  }) {
    return {
      "printerName": printerName,
      "paperWidth": paperWidth == 58 ? 0 : 1,
      "invoiceNumber": int.tryParse(order.orderNumber.toString()) ?? 0,
      "date": DateTime.now().toIso8601String(),
      "orderType": order.orderType.name,
      "department": department,
      "tableNumber": order.tableNumber ?? "",
      "customerName": order.customerName ?? "",
     // "deliveryAddress": order.deliveryAddress ?? "",
      "cashier": "Cashier",

      // تجهيز الأصناف لتطابق KitchenItem في سيرفر الـ C#
      "items": order.items.map((item) {
        final quantity = (item["quantity"] as num?)?.toDouble() ?? 1.0;
        return {
          "name": item["name"] ?? "",
          "price": (item["price"] as num?)?.toDouble() ?? 0.0,
          "quantity": quantity,
          "size": item["size"] ?? "",
          "note": item["note"] ?? "",
        };
      }).toList(),

      // 🌟 إرسال إعدادات التنسيق للسيرفر (تتغير حسب اختيارك في شاشة الإعدادات)
      "formatting": formattingSettings ?? {
        "itemsBold": true,
        "storeNameBold": true,
        "storeNameDoubleHeight": true,
        "invoiceHeaderBold": true,
        "invoiceHeaderDoubleHeight": true,
        "grandTotalBold": true,
        "grandTotalDoubleHeight": true,
      },
    };
  }
}