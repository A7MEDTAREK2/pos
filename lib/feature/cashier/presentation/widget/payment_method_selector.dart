import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/export/print_service.dart';
import '../../../../core/service/printing/mapper/dlivry.dart';
import '../../logic/pos_cubit.dart';

import '../../data/model/pos_model.dart';

class PaymentDialog extends StatefulWidget {
  final double totalAmount;
  final String orderId;
  final VoidCallback onPrintFinalReceipt;

  const PaymentDialog({
    super.key,
    required this.totalAmount,
    required this.orderId,
    required this.onPrintFinalReceipt,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  int selectedPaymentIndex = 0;
  final TextEditingController amountController = TextEditingController();
  double changeAmount = 0.0;
  bool _isProcessing = false;

  String get paymentMethod {
    switch (selectedPaymentIndex) {
      case 0:
        return "Cash";
      case 1:
        return "Visa";
      case 2:
        return "Instapay";
      case 3:
        return "Wallet";
      default:
        return "Cash";
    }
  }

  @override
  void initState() {
    super.initState();
    amountController.text = widget.totalAmount.toStringAsFixed(2);
  }

  void _calculateChange(String value) {
    final enteredAmount = double.tryParse(value) ?? 0.0;
    setState(() {
      changeAmount = enteredAmount > widget.totalAmount
          ? enteredAmount - widget.totalAmount
          : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 800,
        child: Row(
          children: [
            // ================= [ الجزء الأيمن: ملخص الفاتورة ] =================
            Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ملخص الدفع',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSummaryItem(
                    'المطلوب سداده',
                    '${widget.totalAmount.toStringAsFixed(2)} ج.م',
                    Colors.black87,
                    24,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'المبلغ المدفوع',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D53FC),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _calculateChange,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _quickAmountButton(widget.totalAmount),
                      _quickAmountButton(50),
                      _quickAmountButton(100),
                      _quickAmountButton(200),
                      _quickAmountButton(500),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryItem(
                    'الباقي',
                    '${changeAmount.toStringAsFixed(2)} ج.م',
                    _changeColor(),
                    22,
                  ),
                ],
              ),
            ),

            // ================= [ الجزء الأيسر: طرق الدفع ] =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'وسيلة الدفع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        IconButton(
                          onPressed: _isProcessing
                              ? null
                              : () {
                            context.read<OrderCubit>().clearCart();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final methods = [
                          ('نقدًا', Icons.payments_rounded),
                          ('فيزا', Icons.credit_card_rounded),
                          ('انستا باي', Icons.qr_code_scanner_rounded),
                          ('محفظة', Icons.account_balance_wallet_rounded),
                        ];

                        return _buildPaymentMethod(
                          index,
                          methods[index].$1,
                          methods[index].$2,
                        );
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D53FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isProcessing ? null : _processPayment,
                        child: _isProcessing
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'تأكيد وسداد الفاتورة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== معالجة الدفع ======
  Future<void> _processPayment() async {
    final paid = double.tryParse(amountController.text) ?? 0;

    if (paid < widget.totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "المبلغ المدفوع أقل من إجمالي الفاتورة",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final cubit = context.read<OrderCubit>();

      // ====== 1. إتمام الدفع ======
      await cubit.completePayment(widget.orderId);

      if (!context.mounted) return;

      // ====== 2. طباعة الفواتير ======
      //await _printReceipts(cubit);

      if (!context.mounted) return;

      // ====== 3. إغلاق الـ Dialog ======
      Navigator.pop(context);
      widget.onPrintFinalReceipt();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الدفع بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ====== طباعة الفواتير ======
  Future<void> _printReceipts(OrderCubit cubit) async {
    final currentOrder = cubit.currentOrder;

    if (currentOrder == null) return;

    // ====== فاتورة العميل ======
    final customerReceipt = _formatCustomerReceipt(currentOrder);

    // ====== فاتورة المندوب (إذا كان التوصيل) ======
    String? deliveryReceipt;
    if (currentOrder.orderType == OrderType.delivery &&
        currentOrder.driverName != null &&
        currentOrder.driverName!.isNotEmpty) {
      deliveryReceipt = DeliveryFormatter.formatDeliveryReceipt(
        driverName: currentOrder.driverName!,
        orderNumber: currentOrder.orderNumber.toString(),
        date: DateTime.now(),
        customerName: currentOrder.customerName ?? '',
        customerPhone: currentOrder.customerPhone ?? '',
        customerAddress: currentOrder.customerAddress ?? '',
        customerArea: currentOrder.customerArea ?? '',
        paymentMethod: currentOrder.paymentMethod ?? 'نقدي',
        totalAmount: currentOrder.totalAmount,
        items: currentOrder.items,
        notes: null,
      );
    }

    // ====== طباعة الفواتير ======
    await PrintService.printOrderReceipts(
      customerReceipt: customerReceipt,
      deliveryReceipt: deliveryReceipt,
      orderType: currentOrder.orderType.name,
    );
  }

  // ====== تنسيق فاتورة العميل ======
  String _formatCustomerReceipt(OrderModel order) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('=' * 48);
    buffer.writeln('           فاتورة العميل');
    buffer.writeln('=' * 48);
    buffer.writeln();

    // معلومات الطلب
    buffer.writeln('رقم الطلب: ${order.orderNumber}');
    buffer.writeln('التاريخ: ${_formatDate(DateTime.now())}');
    buffer.writeln('نوع الطلب: ${_getOrderTypeText(order.orderType)}');
    buffer.writeln();

    // معلومات العميل
    if (order.customerName != null && order.customerName!.isNotEmpty) {
      buffer.writeln('العميل: ${order.customerName}');
    }
    if (order.customerPhone != null && order.customerPhone!.isNotEmpty) {
      buffer.writeln('الهاتف: ${order.customerPhone}');
    }
    if (order.customerAddress != null && order.customerAddress!.isNotEmpty) {
      buffer.writeln('العنوان: ${order.customerAddress}');
    }
    if (order.customerArea != null && order.customerArea!.isNotEmpty) {
      buffer.writeln('المنطقة: ${order.customerArea}');
    }
    buffer.writeln();

    // الأصناف
    buffer.writeln('-' * 48);
    buffer.writeln('الصنف      الكمية      السعر');
    buffer.writeln('-' * 48);

    for (var item in order.items) {
      final name = item['product_name'] ?? '';
      final quantity = item['quantity'] ?? 0;
      final price = item['price'] ?? 0;
      final total = quantity * price;
      buffer.writeln(
          '${_padRight(name, 15)} ${_padRight(quantity.toString(), 10)} ${total.toStringAsFixed(2)}');
    }

    buffer.writeln('-' * 48);

    // الإجماليات
    buffer.writeln('الإجمالي: ${order.totalAmount.toStringAsFixed(2)}');
    if (order.discount != null && order.discount! > 0) {
      buffer.writeln('الخصم: ${order.discount!.toStringAsFixed(2)}');
    }
    if (order.tax != null && order.tax! > 0) {
      buffer.writeln('الضريبة: ${order.tax!.toStringAsFixed(2)}');
    }
    if (order.deliveryFee != null && order.deliveryFee! > 0) {
      buffer.writeln('رسوم التوصيل: ${order.deliveryFee!.toStringAsFixed(2)}');
    }
    buffer.writeln('المبلغ الإجمالي: ${order.totalAmount.toStringAsFixed(2)}');
    buffer.writeln();

    // طريقة الدفع
    if (order.paymentMethod != null) {
      buffer.writeln('طريقة الدفع: ${order.paymentMethod}');
    }

    buffer.writeln();
    buffer.writeln('=' * 48);
    buffer.writeln('           شكراً لتسوقكم معنا');
    buffer.writeln('=' * 48);

    return buffer.toString();
  }

  String _getOrderTypeText(OrderType type) {
    switch (type) {
      case OrderType.takeAway:
        return 'طلبية خارجية';
      case OrderType.dineIn:
        return 'طلبية داخلية';
      case OrderType.delivery:
        return 'توصيل';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _padRight(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text.padRight(width);
  }

  // ====== باقي الدوال المساعدة ======
  Widget _buildPaymentMethod(int index, String label, IconData icon) {
    final selected = selectedPaymentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _isProcessing
          ? null
          : () {
        final methods = ['Cash', 'Visa', 'Instapay', 'Wallet'];
        context.read<OrderCubit>().setPaymentMethod(
          methods[index],
        );

        setState(() {
          selectedPaymentIndex = index;
        });

        context.read<OrderCubit>().setPaymentMethod(methods[index]);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xff2563EB) : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: selected ? Colors.white : const Color(0xff2563EB),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String title,
      String value,
      Color color,
      double fontSize,
      ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      );

  Widget _quickAmountButton(double amount) {
    final isExact = amount == widget.totalAmount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isProcessing
            ? null
            : () {
          amountController.text = amount.toStringAsFixed(2);
          _calculateChange(amountController.text);
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: isExact ? const Color(0xFF2563EB) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isExact ? const Color(0xFF2563EB) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExact)
                const Icon(Icons.done, color: Colors.white, size: 16),
              if (isExact) const SizedBox(width: 6),
              Text(
                isExact ? "مطابق" : "${amount.toStringAsFixed(0)} ج.م",
                style: TextStyle(
                  color: isExact ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _changeColor() {
    final paid = double.tryParse(amountController.text) ?? 0;

    if (paid < widget.totalAmount) {
      return Colors.red;
    }

    if (paid == widget.totalAmount) {
      return const Color(0xFF2563EB);
    }

    return Colors.green;
  }
}