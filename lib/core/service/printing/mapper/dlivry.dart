/*class DeliveryFormatter {
  static String formatDeliveryReceipt({
    required String driverName,
    required String orderNumber,
    required DateTime date,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required String customerArea,
    required String paymentMethod,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) {
    final buffer = StringBuffer();

    // ====== Header ======
    buffer.writeln('=' * 48);
    buffer.writeln('           ورقة التوصيل - المندوب');
    buffer.writeln('=' * 48);
    buffer.writeln();

    // ====== معلومات المندوب ======
    buffer.writeln('المندوب: $driverName');
    buffer.writeln('رقم الطلب: $orderNumber');
    buffer.writeln('التاريخ: ${_formatDate(date)}');
    buffer.writeln();

    // ====== معلومات العميل ======
    buffer.writeln('-' * 48);
    buffer.writeln('معلومات العميل');
    buffer.writeln('-' * 48);
    buffer.writeln('الاسم: $customerName');
    buffer.writeln('الهاتف: $customerPhone');
    if (customerArea.isNotEmpty) {
      buffer.writeln('المنطقة: $customerArea');
    }
    if (customerAddress.isNotEmpty) {
      buffer.writeln('العنوان: $customerAddress');
    }
    buffer.writeln();

    // ====== معلومات الدفع ======
    buffer.writeln('-' * 48);
    buffer.writeln('معلومات الدفع');
    buffer.writeln('-' * 48);
    buffer.writeln('طريقة الدفع: $paymentMethod');
    buffer.writeln('المبلغ المطلوب تحصيله: ${_formatPrice(totalAmount)}');
    buffer.writeln();

    // ====== الأصناف ======
    buffer.writeln('-' * 48);
    buffer.writeln('الأصناف');
    buffer.writeln('-' * 48);
    buffer.writeln('${_padRight('الكمية', 10)}${_padRight('الصنف', 30)}');
    buffer.writeln('-' * 48);

    for (var item in items) {
      final quantity = item['quantity'] ?? 0;
      final productName = item['product_name'] ?? '';
      buffer.writeln(
          '${_padRight(quantity.toString(), 10)}${_padRight(productName, 30)}');
    }
    buffer.writeln();

    // ====== الملاحظات ======
    if (notes != null && notes.isNotEmpty) {
      buffer.writeln('-' * 48);
      buffer.writeln('الملاحظات: $notes');
      buffer.writeln();
    }

    // ====== إجمالي المبلغ ======
    buffer.writeln('-' * 48);
    buffer.writeln('الإجمالي: ${_formatPrice(totalAmount)}');
    buffer.writeln();

    // ====== Footer ======
    buffer.writeln('=' * 48);
    buffer.writeln('           شكراً لتسوقكم معنا');
    buffer.writeln('=' * 48);

    return buffer.toString();
  }

  static String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ريال';
  }

  static String _padRight(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text.padRight(width);
  }
}*/