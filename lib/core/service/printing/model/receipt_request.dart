import 'receipt_item.dart';

class ReceiptRequest {
  final String printerName;
  final int paperWidth;

  final String storeName;
  final String phone;
  final String address;
  final String taxNumber;

  final int invoiceNumber;

  final String cashier;

  final String customerName;
  final String customerPhone;

  final String orderType;

  final String paymentMethod;

  final double subtotal;
  final double discount;
  final double tax;
  final double delivery;
  final double total;

  final List<ReceiptItem> items;

  ReceiptRequest({
    required this.printerName,
    required this.paperWidth,
    required this.storeName,
    required this.phone,
    required this.address,
    required this.taxNumber,
    required this.invoiceNumber,
    required this.cashier,
    required this.customerName,
    required this.customerPhone,
    required this.orderType,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.delivery,
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "printerName": printerName,
      "paperWidth": paperWidth,
      "storeName": storeName,
      "phone": phone,
      "address": address,
      "taxNumber": taxNumber,
      "invoiceNumber": invoiceNumber,
      "cashier": cashier,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "orderType": orderType,
      "paymentMethod": paymentMethod,
      "subtotal": subtotal,
      "discount": discount,
      "tax": tax,
      "delivery": delivery,
      "total": total,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}