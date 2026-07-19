import 'package:flutter/material.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class EditableSummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final VoidCallback onTap;

  const EditableSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colorsmanegments.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colorsmanegments.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colorsmanegments.primary,
              size: 18,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TxtStyle.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "${value.toStringAsFixed(2)} ج.م",
              style: TxtStyle.tableRowBold,
            ),
          ],
        ),
      ),
    );
  }
}