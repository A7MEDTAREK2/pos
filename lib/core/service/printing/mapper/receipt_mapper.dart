// lib/core/service/printing/mapper/receipt_mapper.dart

import '../../../../feature/cashier/data/model/pos_model.dart';
import '../../../../feature/setting/data/model/settings_model.dart';

class ReceiptMapper {

  /// 1. Mapper لفورمات بون الكاشير
  static Map<String, dynamic> toCashierPayload({
    required OrderModel order,
    required SettingsModel? settings,
    required String printerName,
  }) {
    double calculatedSubtotal = 0.0;

    final products = order.items.map((e) {
      final price = double.tryParse(e["price"].toString()) ?? 0.0;
      final quantity = int.tryParse(e["quantity"].toString()) ?? 1;
      final itemTotal = price * quantity;

      calculatedSubtotal += itemTotal;

      return {
        "name": e["name"].toString(),
        "qty": quantity,
        "size": e["size"]?.toString() ?? "",
        "note": e["note"]?.toString() ?? "",
        "price": price,
        "total": itemTotal,
      };
    }).toList();

    // ✅ التصحيح هنا بالتعامل الآمن مع الـ null
    final double subTotal = (order.subtotal != null && order.subtotal! > 0)
        ? order.subtotal!.toDouble()
        : calculatedSubtotal;

    final double discount = (order.discount ?? 0).toDouble();
    final double tax = (order.tax ?? 0).toDouble();
    final double delivery = (order.deliveryFee ?? 0).toDouble();

    final double grandTotal = (subTotal - discount) + tax + delivery;

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

      "subTotal": subTotal,
      "discount": discount,
      "tax": tax,
      "delivery": delivery,
      "grandTotal": grandTotal,
    };
  }

  /// 2. Mapper لفورمات بون الدليفري
  static Map<String, dynamic> toDeliveryPayload({
    required OrderModel order,
    required SettingsModel? settings,
    required String printerName,
  }) {
    double calculatedSubtotal = 0.0;

    final products = order.items.map((e) {
      final price = double.tryParse(e["price"].toString()) ?? 0.0;
      final quantity = int.tryParse(e["quantity"].toString()) ?? 1;
      final itemTotal = price * quantity;

      calculatedSubtotal += itemTotal;

      return {
        "name": e["name"].toString(),
        "qty": quantity,
        "size": e["size"]?.toString() ?? "",
        "note": e["note"]?.toString() ?? "",
        "price": price,
        "total": itemTotal,
      };
    }).toList();

    // ✅ التصحيح هنا أيضاً للتعامل الآمن مع الـ null
    final double subTotal = (order.subtotal != null && order.subtotal! > 0)
        ? order.subtotal!.toDouble()
        : calculatedSubtotal;

    final double discount = (order.discount ?? 0).toDouble();
    final double tax = (order.tax ?? 0).toDouble();
    final double delivery = (order.deliveryFee ?? 0).toDouble();

    final double grandTotal = (subTotal - discount) + tax + delivery;

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
      "deliverymanName": order.driverName ?? "",

      "orderType": "دليفري",
      "paymentMethod": order.paymentMethod ?? "Cash",

      "products": products,

      "subTotal": subTotal,
      "discount": discount,
      "tax": tax,
      "delivery": delivery,
      "grandTotal": grandTotal,
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