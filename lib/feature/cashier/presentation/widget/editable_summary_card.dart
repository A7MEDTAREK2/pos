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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: _getTooltipMessage(title),
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 18,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                "${value.toStringAsFixed(2)} ج.م",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTooltipMessage(String title) {
    switch (title) {
      case "الضريبة":
        return "Ctrl + T - تعديل الضريبة";
      case "التوصيل":
        return "Ctrl + r - تعديل رسوم التوصيل";
      case "الخصم":
        return "Ctrl + C - تعديل الخصم";
      default:
        return title;
    }
  }
}