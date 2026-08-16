// lib/feature/reports/payment_report/presentation/widgets/payment_table_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentTableHeader extends StatelessWidget {
  const PaymentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          _headerCell(context, '#', flex: 1),
          _headerCell(context, 'طريقة الدفع', flex: 3),
          _headerCell(context, 'عدد العمليات', flex: 2),
          _headerCell(context, 'إجمالي الإيراد', flex: 3),
          _headerCell(context, 'متوسط قيمة العملية', flex: 3),
        ],
      ),
    );
  }

  Widget _headerCell(BuildContext context, String text, {int flex = 1}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}