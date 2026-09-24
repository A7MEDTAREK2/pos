// lib/feature/cashier/presentation/widget/cart_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/service/printing/printing_manager.dart';
import '../../../../core/theming/colors manegments.dart';

// ====== Cashier ======
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../data/model/pos_model.dart';
import '../../logic/pos_cubit.dart';
import '../screen/holding_orders_screen.dart';
import 'payment_method_selector.dart'; // تأكد من استيراد دايلوج الدفع

class CartActionButtons extends StatelessWidget {
  final OrderModel? currentOrder;
  final OrderType orderType;
  final double totalAmount;

  const CartActionButtons({
    super.key,
    required this.currentOrder,
    required this.orderType,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ====== 1. زرار عرض المعلقة + زرار حفظ/تحديث الأوردر ======
        Row(
          children: [
            Expanded(
              child: Tooltip(
                message: "F4 - الأوردرات المعلقة",
                waitDuration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.withOpacity(0.1),
                      foregroundColor: Colors.amber,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.amber.withOpacity(0.2)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<OrderCubit>(),
                            child: const HoldingOrdersScreen(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Iconss.bookmark,
                      size: 18,
                      color: Colors.amber,
                    ),
                    label: Text(
                      "المعلقة",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Tooltip(
                message: "حفظ أو تحديث الأوردر الحالي",
                waitDuration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      foregroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blue.withOpacity(0.2)),
                      ),
                    ),
                    onPressed: () async {
                      final cubit = context.read<OrderCubit>();
                      if (cubit.cartItems.isEmpty) {
                        _showValidationErrorDialog(context, "السلة فارغة!", "تنبيه");
                        return;
                      }

                      if (orderType == OrderType.delivery) {
                        final String? validationError = cubit.validateDeliveryOrder();
                        if (validationError != null) {
                          if (!context.mounted) return;
                          _showValidationErrorDialog(context, validationError, 'بيانات غير مكتملة');
                          return;
                        }
                      }

                      await cubit.holdOrder(clearAfterSave: true);
                      if (!context.mounted) return;
                      _showSuccessDialog(context, 'تم حفظ/تحديث الأوردر بنجاح');
                    },
                    icon: const Icon(
                      Icons.bookmark_add,
                      size: 18,
                      color: Colors.blue,
                    ),
                    label: Text(
                      "حفظ الأوردر",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),

        // ====== 2. زرار إتمام الدفع (الذي يفتح دايلوج الدفع) ======
        Tooltip(
          message: "F1 - إتمام الدفع",
          waitDuration: const Duration(milliseconds: 300),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: () => _openPaymentPopup(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconss.print,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إتمام الدفع',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} ج.م',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // دالة فتح دايلوج الدفع
  Future<void> _openPaymentPopup(BuildContext context) async {
    final cubit = context.read<OrderCubit>();

    if (cubit.cartItems.isEmpty) {
      _showValidationErrorDialog(context, "السلة فارغة!", "تنبيه");
      return;
    }

    if (orderType == OrderType.delivery) {
      final String? validationError = cubit.validateDeliveryOrder();
      if (validationError != null) {
        if (!context.mounted) return;
        _showValidationErrorDialog(context, validationError, 'بيانات غير مكتملة');
        return;
      }
    }

    // حفظ الأوردر مؤقتاً للحصول على الـ ID الخاص به قبل فتح الدايلوج
    final order = await cubit.holdOrder(clearAfterSave: false);
    if (order == null) return;

    if (!context.mounted) return;

    // فتح نافذة الدفع
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: PaymentDialog(
          orderId: order.id,
          totalAmount: totalAmount,
          onPrintFinalReceipt: () {},
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 55),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'حسناً',
                  style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showValidationErrorDialog(BuildContext context, String validationError, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          validationError,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}