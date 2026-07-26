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
                      backgroundColor: Colorsmanegments.warning.withOpacity(0.1),
                      foregroundColor: Colorsmanegments.warning,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colorsmanegments.warning.withOpacity(0.2)),
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
                      color: Colorsmanegments.warning,
                    ),
                    label: Text(
                      "حفظ الأوردر",
                      style: TxtStyle.buttonSmall.copyWith(
                        color: Colorsmanegments.warning,
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
                      foregroundColor: Colorsmanegments.danger,
                      side: BorderSide(color: Colorsmanegments.danger),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.read<OrderCubit>().clearCart(),
                    icon: Icon(
                      Iconss.delete,
                      size: 18,
                      color: Colorsmanegments.danger,
                    ),
                    label: Text(
                      "مسح السلة",
                      style: TxtStyle.buttonSmall.copyWith(
                        color: Colorsmanegments.danger,
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
                backgroundColor: Colorsmanegments.success,
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
                    color: Colorsmanegments.textWhite,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إنهاء الدفع',
                    style: TxtStyle.buttonLarge.copyWith(
                      color: Colorsmanegments.textWhite,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} ج.م',
                    style: TxtStyle.buttonLarge.copyWith(
                      color: Colorsmanegments.textWhite,
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

// طباعة ورقة المطبخ

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