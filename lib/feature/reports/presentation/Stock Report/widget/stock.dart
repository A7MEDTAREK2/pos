// lib/feature/reports/stock_report/presentation/widgets/stock_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockTableRow extends StatefulWidget {
  const StockTableRow({
    super.key,
    required this.index,
    required this.productName,
    required this.quantity,
    required this.stockValue,
    required this.status,
    required this.isEven,
  });

  final int index;
  final String productName;
  final int quantity;
  final double stockValue;
  final String status;
  final bool isEven;

  @override
  State<StockTableRow> createState() => _StockTableRowState();
}

class _StockTableRowState extends State<StockTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isLowStock = widget.status == 'منخفض';
    final isOutOfStock = widget.status == 'نفد';
    final statusColor = isLowStock
        ? Colors.amber
        : isOutOfStock
        ? Colors.red
        : Colors.green;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _getRowColor(colorScheme),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFF1F5F9),
              width: 0.5,
            ),
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            _buildCell(
              context,
              text: widget.index.toString(),
              flex: 1,
              isIndex: true,
            ),
            _buildCell(
              context,
              text: widget.productName,
              flex: 3,
              isBold: true,
            ),
            _buildCell(
              context,
              text: '${widget.quantity}',
              flex: 2,
            ),
            _buildCell(
              context,
              text: '${widget.stockValue.toStringAsFixed(2)} ج.م',
              flex: 2,
              isRevenue: true,
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: statusColor.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    widget.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(
      BuildContext context, {
        required String text,
        int flex = 1,
        bool isBold = false,
        bool isIndex = false,
        bool isRevenue = false,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: isBold || isRevenue ? FontWeight.w600 : FontWeight.w400,
          color: isRevenue
              ? Colors.green
              : isIndex
              ? colorScheme.onSurface.withOpacity(0.4)
              : colorScheme.onSurface,
        ),
      ),
    );
  }

  Color _getRowColor(ColorScheme colorScheme) {
    if (_isHovered) {
      return colorScheme.primary.withOpacity(0.04);
    }
    return widget.isEven
        ? colorScheme.background
        : colorScheme.surface;
  }
}