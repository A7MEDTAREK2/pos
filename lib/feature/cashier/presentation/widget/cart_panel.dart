import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../cashier/logic/pos_cubit.dart';
import '../../../cashier/presentation/widget/cart_action_buttons.dart.dart';
import '../../../cashier/presentation/widget/dynamic_order_fields.dart';
import '../../../cashier/presentation/widget/order_type_selector.dart';

import '../../../driver/logic/drive_cubit.dart';
import '../../../driver/logic/drive_state.dart';
import '../../../driver/pre/dropdown.dart';
import '../../data/model/pos_model.dart';
import '../helper/pos_helpers.dart';
import 'cart_items_list.dart';
import 'edit_amount_dialog.dart';
import 'financial_summary.dart';

class CartPanel extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final PosTotals totals;
  final OrderCubit cubit;

  const CartPanel({
    super.key,
    required this.cartItems,
    required this.totals,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 550,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildOrderTypeSelector(context),
          Flexible(
            child: Container(
              color: colorScheme.background,
              child: CartItemsList(
                items: cartItems,
                cubit: cubit,
              ),
            ),
          ),
          // ====== Financial Summary ======
          PosFinancialSummary(
            totals: totals,
            isDelivery: cubit.selectedOrderType == OrderType.delivery,
            onTaxTap: () => _editValue(
              context: context,
              title: "الضريبة",
              currentValue: totals.tax,
              onSave: (v) => cubit.setTaxPercent(v),
            ),
            onDeliveryTap: () => _editValue(
              context: context,
              title: "رسوم التوصيل",
              currentValue: totals.delivery,
              onSave: (v) => cubit.setDeliveryFee(v),
            ),
            onDiscountTap: () => _editValue(
              context: context,
              title: "الخصم",
              currentValue: totals.discount,
              onSave: (v) => cubit.setDiscount(v),
            ),
          ),
          // ====== Driver Dropdown (for Delivery) ======
          if (cubit.selectedOrderType == OrderType.delivery) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: BlocBuilder<DriverCubit, DriverState>(
                builder: (context, driverState) {
                  return DriverDropdown(
                    selectedDriverName: cubit.driverName,
                    onDriverSelected: (name) {
                      cubit.setDriver(name);
                    },
                  );
                },
              ),
            ),
          ],
          // ====== Action Buttons ======
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            child: CartActionButtons(
              currentOrder: cubit.currentOrder,
              orderType: OrderType.values[cubit.selectedOrderType.index],
              totalAmount: totals.finalTotal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconss.cart,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "الطلب الحالي",
            style: theme.textTheme.titleMedium,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${cartItems.length} منتج",
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              OrderTypeSelector(
                selectedIndex: cubit.selectedOrderType.index,
                orderNumber: cubit.currentOrder?.orderNumber ?? 0,
                onTypeChanged: (i) {
                  context.read<OrderCubit>().changeOrderType(
                    OrderType.values[i],
                  );
                },
              ),
              const SizedBox(height: 3),
              DynamicOrderFields(
                orderTypeIndex: cubit.selectedOrderType.index,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editValue({
    required BuildContext context,
    required String title,
    required double currentValue,
    required Function(double) onSave,
  }) async {
    final value = await showDialog<double>(
      context: context,
      builder: (_) => EditAmountDialog(title: title, value: currentValue),
    );

    if (value != null) {
      onSave(value);
    }
  }
}