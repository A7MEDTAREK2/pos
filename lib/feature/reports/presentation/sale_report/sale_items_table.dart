// lib/feature/sales/presentation/widgets/invoice_details/sale_items_table.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sale_detail_report.dart';

class SaleItemsTable extends StatelessWidget {
  final List<SaleItemModel> items;

  const SaleItemsTable({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // ====== Header ======
          _buildHeader(context),

          // ====== Rows ======
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildRow(context, item, index);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          _headerCell(context, 'المنتج', flex: 4),
          _headerCell(context, 'الحجم', flex: 2),
          _headerCell(context, 'الكمية', flex: 2),
          _headerCell(context, 'السعر', flex: 2),
          _headerCell(context, 'الإجمالي', flex: 2),
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
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, SaleItemModel item, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isEven ? colorScheme.background : colorScheme.surface,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        children: [
          _rowCell(context, item.productName, flex: 4),
          _rowCell(context, item.sizeName ?? '--', flex: 2),
          _rowCell(context, '${item.quantity}', flex: 2),
          _rowCell(context, '${item.price.toStringAsFixed(2)} ج.م', flex: 2),
          _rowCell(
            context,
            '${(item.price * item.quantity).toStringAsFixed(2)} ج.م',
            flex: 2,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _rowCell(
      BuildContext context,
      String text, {
        int flex = 1,
        bool isTotal = false,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? Colors.green : colorScheme.onSurface,
        ),
      ),
    );
  }
}