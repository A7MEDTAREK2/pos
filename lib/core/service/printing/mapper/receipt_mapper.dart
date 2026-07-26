// lib/core/service/printing/service/receipt_mapper.dart

import '../../../../feature/cashier/data/model/pos_model.dart';
import '../../../../feature/setting/data/model/settings_model.dart';

class ReceiptMapper {

  /// 1. Mapper لفورمات بون الكاشير
  static Map<String, dynamic> toCashierPayload({
    required OrderModel order,
    required SettingsModel? settings,
    required String printerName,
  }) {
    final products = order.items.map((e) {
      final price = double.tryParse(e["price"].toString()) ?? 0.0;
      final quantity = int.tryParse(e["quantity"].toString()) ?? 1;

      return {
        "name": e["name"].toString(),
        "qty": quantity,
        "size": e["size"]?.toString() ?? "",
        "note": e["note"]?.toString() ?? "",
        "price": price,
        "total": price * quantity,
      };
    }).toList();

    return {
      "printerName": printerName,
      "paperWidth": settings?.paperWidth ?? 80,
      "storeName": settings?.storeName?.isNotEmpty == true ? settings!.storeName : "Modu POS",
      "storePhone": settings?.phone ?? "",
      "secondaryPhone": "",
      "storeAddress": settings?.address ?? "",
      "taxNumber": settings?.taxNumber ?? "",
      "currency": settings?.currency ?? "ج.م",

      "formatting": {
        "storeNameBold": true,
        "storeNameDoubleHeight": true,
        "invoiceHeaderBold": true,
        "invoiceHeaderDoubleHeight": true,
        "itemsBold": false,
        "grandTotalBold": true,
        "grandTotalDoubleHeight": true,
      },

      "showLogo": settings?.showLogo ?? true,
      "showAddress": settings?.showAddress ?? true,
      "showPhone": settings?.showPhone ?? true,
      "showTaxNumber": settings?.showTaxNumber ?? false,
      "showQr": settings?.showQr ?? true,
      "footer": settings?.footerMessage ?? "",

      "invoiceNumber": order.orderNumber,
      "date": order.createdAt.toIso8601String(),
      "cashier": "Admin",
      "customerName": order.customerName ?? "",
      "customerPhone": order.customerPhone ?? "",
      "orderType": order.orderType.name,
      "paymentMethod": order.paymentMethod ?? "Cash",

      "products": products,

      "subTotal": (order.subtotal ?? order.totalAmount).toDouble(),
      "discount": (order.discount ?? 0).toDouble(),
      "tax": (order.tax ?? 0).toDouble(),
      "delivery": (order.deliveryFee ?? 0).toDouble(),
      "grandTotal": order.totalAmount.toDouble(),
    };
  }

  /// 2. Mapper لفورمات بون الدليفري
  static Map<String, dynamic> toDeliveryPayload({
    required OrderModel order,
    required SettingsModel? settings,
    required String printerName,
  }) {
    final products = order.items.map((e) {
      final price = double.tryParse(e["price"].toString()) ?? 0.0;
      final quantity = int.tryParse(e["quantity"].toString()) ?? 1;

      return {
        "name": e["name"].toString(),
        "qty": quantity,
        "size": e["size"]?.toString() ?? "",
        "note": e["note"]?.toString() ?? "",
        "price": price,
        "total": price * quantity,
      };
    }).toList();

    return {
      "printerName": printerName,
      "paperWidth": settings?.paperWidth ?? 80,
      "storeName": settings?.storeName?.isNotEmpty == true ? settings!.storeName : "Modu POS",
      "phone": settings?.phone ?? "",

      "formatting": {
        "storeNameBold": true,
        "storeNameDoubleHeight": true,
        "invoiceHeaderBold": true,
        "invoiceHeaderDoubleHeight": false,
        "grandTotalBold": true,
        "grandTotalDoubleHeight": true,
      },

      "invoiceNumber": order.orderNumber,
      "date": order.createdAt.toIso8601String(),
      "cashier": "Admin",
      "customerName": order.customerName ?? "",
      "customerPhone": order.customerPhone ?? "",
      "deliveryAddress": order.customerAddress ?? "",

      // تم الربط هنا بالاسم الصحيح الموجود في الـ OrderModel
      "deliverymanName": order.driverName ?? "",

      "orderType": "دليفري",
      "paymentMethod": order.paymentMethod ?? "Cash",

      "products": products,

      "subTotal": (order.subtotal ?? order.totalAmount).toDouble(),
      "discount": (order.discount ?? 0).toDouble(),
      "tax": 0.0,
      "delivery": (order.deliveryFee ?? 0).toDouble(),
      "grandTotal": order.totalAmount.toDouble(),
    };
  }

  /// 3. Mapper لفورمات بون المطبخ (Kitchen)
  static Map<String, dynamic> toKitchenPayload({
    required OrderModel order,
    required SettingsModel? settings,
    required String printerName,
    required String department,
    required List<Map<String, dynamic>> items,
  }) {
    return {
      "printerName": printerName,
      "paperWidth": settings?.paperWidth ?? 80,
      "storeName": "Modu POS - المطبخ",
      "invoiceNumber": order.orderNumber,
      "date": order.createdAt.toIso8601String(),
      "orderType": order.orderType.name,
      "tableNumber": order.tableNumber ?? "",
      "customerName": order.customerName ?? "",
      "deliveryAddress": order.customerAddress ?? "",
      "cashier": "Admin",
      "department": department,
      "items": items,
    };
  }
}