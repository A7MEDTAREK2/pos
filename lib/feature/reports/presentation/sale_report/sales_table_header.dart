import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesTableHeader extends StatelessWidget {
  const SalesTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.background,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _HeaderCell(context, "م", flex: 1),
          _HeaderCell(context, "رقم الفاتورة", flex: 2),
          _HeaderCell(context, "العميل", flex: 3),
          _HeaderCell(context, "نوع الطلب", flex: 2),
          _HeaderCell(context, "الدفع", flex: 2),
          _HeaderCell(context, "الإجمالي", flex: 2),
          _HeaderCell(context, "التاريخ", flex: 2),
          _HeaderCell(context, "الإجراءات", flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const _HeaderCell(
      this.context,
      this.title, {
        this.flex = 1,
      });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}