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
      width: 530, // عرض لوحة السلة والعمليات الجانبية
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // 1. رأس اللوحة (عنوان "الطلب الحالي" وعدد المنتجات)
          _buildHeader(context),

          // 2. محدد نوع الأوردر (دليفري، صالة، تيك أواي) مع الحقول الخاصة بها
          _buildOrderTypeSelector(context),

          // 3. قائمة المنتجات المضافة للسلة (تأخذ المساحة المتبقية بشكل مرن)
          Expanded(
            child: Container(
              color: colorScheme.background,
              child: CartItemsList(
              ),
            ),
          ),

          // 4. الملخص المالي (الخصم، الضريبة، التوصيل، الإجمالي)
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

          // 5. قائمة اختيار مندوب التوصيل (تظهر فقط في حالة كان الأوردر دليفري)
          if (cubit.selectedOrderType == OrderType.delivery) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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

          // 6. أزرار الإجراءات السفلية (حفظ الأوردر، مسح السلة، وإنهاء الدفع)
          Padding(
            padding: const EdgeInsets.all(10),
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

  // بناء رأس اللوحة العلوي
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            size: 30,
          ),
          const SizedBox(width: 8),
          Text(
            "الطلب الحالي",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
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

  // بناء حاوية اختيار نوع الأوردر وبيانات العميل المرتبطة به
  Widget _buildOrderTypeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
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
              const SizedBox(height: 2),
              DynamicOrderFields(
                orderTypeIndex: cubit.selectedOrderType.index,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإظهار نافذة تعديل القيم المالية (ضريبة، خصم، توصيل)
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