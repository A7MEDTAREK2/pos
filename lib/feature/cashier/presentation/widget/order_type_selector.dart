// lib/feature/cashier/presentation/widget/order_type_selector.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class OrderTypeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTypeChanged;
  final int orderNumber;

  const OrderTypeSelector({
    super.key,
    required this.selectedIndex,
    required this.onTypeChanged,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colorsmanegments.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: _buildButton(0, 'تيك أواي', Iconss.takeaway)),
              Expanded(child: _buildButton(1, 'صالة', Iconss.tableRestaurant)),
              Expanded(child: _buildButton(2, 'دليفري', Iconss.delivery)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(int index, String label, IconData icon) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTypeChanged(index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colorsmanegments.card : Colorsmanegments.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colorsmanegments.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colorsmanegments.primary
                  : Colorsmanegments.textSecondary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? TxtStyle.buttonPrimary.copyWith(
                fontSize: 11,
              )
                  : TxtStyle.bodySmall.copyWith(
                fontSize: 11,
                color: Colorsmanegments.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}