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
import 'payment_method_selector.dart';

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
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ====== 1. حفظ الأوردر + مسح السلة ======
        Row(
          children: [
            Expanded(
              child: Tooltip(
                message: "F4 - حفظ الأوردر",
                waitDuration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 50,
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
                    icon: Icon(
                      Iconss.bookmark,
                      size: 18,
                      color: Colors.amber,
                    ),
                    label: Text(
                      "حفظ الأوردر",
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
                message: "Ctrl + X - مسح السلة",
                waitDuration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.read<OrderCubit>().clearCart(),
                    icon: Icon(
                      Iconss.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                    label: Text(
                      "مسح السلة",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.red,
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

        // ====== 2. إنهاء الدفع ======
        Tooltip(
          message: "F1 - إنهاء الطلب",
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
                  Icon(
                    Iconss.print,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إنهاء الدفع',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} ج.م',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
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

  Future<void> _openPaymentPopup(BuildContext context) async {
    final cubit = context.read<OrderCubit>();

    final order = await cubit.holdOrder(clearAfterSave: false);
    if (order == null) return;

    if (!context.mounted) return;
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
}