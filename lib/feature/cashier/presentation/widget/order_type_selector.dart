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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: _buildButton(context, 0, 'تيك أواي', Iconss.takeaway)),
              Expanded(child: _buildButton(context, 1, 'صالة', Iconss.tableRestaurant)),
              Expanded(child: _buildButton(context, 2, 'دليفري', Iconss.delivery)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, int index, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedIndex == index;

    return Tooltip(
      message: _getTooltipMessage(index, label),
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: () => onTypeChanged(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
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
                    ? colorScheme.primary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: isSelected
                    ? theme.textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                )
                    : theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTooltipMessage(int index, String label) {
    switch (index) {
      case 0:
        return "Ctrl + 1 - تيك أواي";
      case 1:
        return "Ctrl + 2 - صالة";
      case 2:
        return "Ctrl + 3 - دليفري";
      default:
        return label;
    }
  }
}