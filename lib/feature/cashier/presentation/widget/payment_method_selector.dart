import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/service/export/print_service.dart';
import '../../../../core/service/printing/mapper/receipt_mapper.dart';
import '../../../setting/data/model/settings_model.dart';
import '../../../setting/logic/set_cubit.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
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
                color: colorScheme.background,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص الدفع',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSummaryItem(
                    'المطلوب سداده',
                    '${widget.totalAmount.toStringAsFixed(2)} ج.م',
                    theme.textTheme.bodyLarge?.color ?? Colors.black87,
                    24,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'المبلغ المدفوع',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Tooltip(
                    message: "Ctrl + A - تعديل المبلغ",
                    waitDuration: const Duration(milliseconds: 300),
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _calculateChange,
                    ),
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
                        Text(
                          'وسيلة الدفع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Tooltip(
                          message: "Esc - إغلاق",
                          waitDuration: const Duration(milliseconds: 300),
                          child: IconButton(
                            onPressed: _isProcessing
                                ? null
                                : () {
                              context.read<OrderCubit>().clearCart();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
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
                          context,
                          index,
                          methods[index].$1,
                          methods[index].$2,
                        );
                      },
                    ),
                    const Spacer(),
                    Tooltip(
                      message: "Enter - تأكيد الدفع",
                      waitDuration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _isProcessing ? null : _processPayment,
                          child: _isProcessing
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                              : Text(
                            'تأكيد وسداد الفاتورة',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
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
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final cubit = context.read<OrderCubit>();

      await cubit.completePayment(widget.orderId);

      if (!context.mounted) return;

      await _printReceipts(cubit);

      if (!context.mounted) return;

      Navigator.pop(context);
      widget.onPrintFinalReceipt();

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // ====== طباعة الفواتير ======
  Future<void> _printReceipts(OrderCubit cubit) async {
    final currentOrder = cubit.currentOrder;
    if (currentOrder == null) return;

    final prefs = await SharedPreferences.getInstance();
    bool printCustomer = prefs.getBool('printCustomerCopy') ?? true;
    bool printDelivery = prefs.getBool('printDeliveryCopy') ?? false;
    String cashierPrinterName =
        prefs.getString('cashierPrinter') ?? "DefaultPrinter";

    SettingsModel? currentSettings;
    try {
      currentSettings = context.read<SettingsCubit>().settings;
    } catch (_) {}

    Map<String, dynamic>? cashierPayload;
    if (printCustomer) {
      cashierPayload = ReceiptMapper.toCashierPayload(
        order: currentOrder,
        settings: currentSettings,
        printerName: cashierPrinterName,
      );
    }

    Map<String, dynamic>? deliveryPayload;
    if (currentOrder.orderType == OrderType.delivery &&
        currentOrder.driverName != null &&
        currentOrder.driverName!.isNotEmpty &&
        printDelivery) {
      deliveryPayload = ReceiptMapper.toDeliveryPayload(
        order: currentOrder,
        settings: currentSettings,
        printerName: cashierPrinterName,
      );

      deliveryPayload['copies'] = 2;
    }
  }

  // ====== دوال مساعدة ======
  Widget _buildPaymentMethod(BuildContext context, int index, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = selectedPaymentIndex == index;

    return Tooltip(
      message: _getPaymentMethodTooltip(index, label),
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
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
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
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
                color: selected ? colorScheme.onPrimary : colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selected ? colorScheme.onPrimary : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodTooltip(int index, String label) {
    switch (index) {
      case 0:
        return "Ctrl + 1 - نقدًا";
      case 1:
        return "Ctrl + 2 - فيزا";
      case 2:
        return "Ctrl + 3 - انستا باي";
      case 3:
        return "Ctrl + 4 - محفظة";
      default:
        return label;
    }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExact = amount == widget.totalAmount;

    return Tooltip(
      message: "Ctrl + ${_getQuickAmountShortcut(amount)} - ${amount.toStringAsFixed(0)} ج.م",
      waitDuration: const Duration(milliseconds: 300),
      child: Material(
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
              color: isExact ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isExact ? colorScheme.primary : colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isExact)
                  Icon(Icons.done, color: colorScheme.onPrimary, size: 16),
                if (isExact) const SizedBox(width: 6),
                Text(
                  isExact ? "مطابق" : "${amount.toStringAsFixed(0)} ج.م",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isExact ? colorScheme.onPrimary : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getQuickAmountShortcut(double amount) {
    if (amount == widget.totalAmount) return "E";
    switch (amount.toInt()) {
      case 50:
        return "5";
      case 100:
        return "6";
      case 200:
        return "7";
      case 500:
        return "8";
      default:
        return "";
    }
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