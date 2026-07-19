class KitchenFormatter {
  static String formatKitchenReceipt({
    required String restaurantName,
    required String branchName,
    required String branchAddress,
    required DateTime date,
    required List<KitchenItem> items,
    String? invoiceNumber,
    String? orderType,
    String? tableNumber,
    String? customerName,
    String? deliveryAddress,
  }) {
    final buffer = StringBuffer();

    // ================================================
    // HEADER - اسم المطعم
    // ================================================
    buffer.writeln('=' * 40);
    buffer.writeln('           ${_centerText(restaurantName, 40)}');
    buffer.writeln('=' * 40);
    buffer.writeln();

    // ================================================
    // اسم الفرع / القسم
    // ================================================
    if (branchName.isNotEmpty) {
      buffer.writeln('           ${_centerText(branchName, 40)}');
      buffer.writeln();
    }

    // ================================================
    // معلومات الطلب - سطر واحد
    // ================================================
    if (branchAddress.isNotEmpty) {
      buffer.writeln('           ${_centerText(branchAddress, 40)}');
      buffer.writeln();
    }

    // ================================================
    // التاريخ والوقت
    // ================================================
    buffer.writeln('-' * 40);
    buffer.writeln('تاريخ اليوم : ${_formatDate(date)}');
    buffer.writeln('الوقت الحالى : ${_formatTime(date)}');
    buffer.writeln('تاريخ الاستلام : ');
    buffer.writeln('-' * 40);

    // ================================================
    // معلومات الطلب الإضافية
    // ================================================
    if (invoiceNumber != null && invoiceNumber.isNotEmpty) {
      buffer.writeln('رقم الطلب : $invoiceNumber');
    }
    if (orderType != null && orderType.isNotEmpty) {
      buffer.writeln('نوع الطلب : $orderType');
    }
    if (tableNumber != null && tableNumber.isNotEmpty) {
      buffer.writeln('الطاولة : $tableNumber');
    }
    if (customerName != null && customerName.isNotEmpty) {
      buffer.writeln('العميل : $customerName');
    }
    if (deliveryAddress != null && deliveryAddress.isNotEmpty) {
      buffer.writeln('العنوان : $deliveryAddress');
    }

    buffer.writeln('-' * 40);

    // ================================================
    // ITEMS HEADER
    // ================================================
    buffer.writeln('${_padRight('السعر', 12)}${_padRight('عقد', 10)}اسم الصنف');
    buffer.writeln('-' * 40);

    // ================================================
    // ITEMS
    // ================================================
    for (var item in items) {
      var name = item.name;
      if (item.size != null && item.size!.isNotEmpty) {
        name += ' ${item.size}';
      }

      final price = item.price.toStringAsFixed(2);
      final quantity = item.quantity.toStringAsFixed(3);

      buffer.writeln(
          '${_padRight(price, 12)}${_padRight(quantity, 10)}$name');
    }

    buffer.writeln('-' * 40);

    // ================================================
    // FOOTER - نسخة المطعم
    // ================================================
    buffer.writeln();
    buffer.writeln('           ${_centerText('نسخة المطعم', 40)}');
    buffer.writeln();
    buffer.writeln('=' * 40);

    return buffer.toString();
  }

  static String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'م' : 'ص';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }

  static String _centerText(String text, int width) {
    final spaces = (width - text.length) ~/ 2;
    if (spaces <= 0) return text;
    return ' ' * spaces + text;
  }

  static String _padRight(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text.padRight(width);
  }
}

class KitchenItem {
  final String name;
  final double price;
  final double quantity;
  final String? size;
  final String? note;

  KitchenItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.size,
    this.note,
  });
}