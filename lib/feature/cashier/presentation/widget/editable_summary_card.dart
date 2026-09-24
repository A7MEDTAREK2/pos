// lib/feature/cashier/presentation/widget/editable_summary_card.dart

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
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة البطاقة بحجم مصغر
              Icon(
                icon,
                color: colorScheme.primary,
                size: 16,
              ),
              const SizedBox(height: 3),
              // عنوان البطاقة
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 2),
              // القيمة المالية بخط مدمج
              Text(
                "${value.toStringAsFixed(2)} ج.م",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تحديد رسالة الـ Tooltip واختصارات لوحة المفاتيح
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