// lib/feature/reports/order_type_report/presentation/widgets/order_type_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderTypeTableRow extends StatefulWidget {
  const OrderTypeTableRow({
    super.key,
    required this.index,
    required this.orderType,
    required this.orderCount,
    required this.totalRevenue,
    required this.averageValue,
    required this.isEven,
  });

  final int index;
  final String orderType;
  final int orderCount;
  final double totalRevenue;
  final double averageValue;
  final bool isEven;

  @override
  State<OrderTypeTableRow> createState() => _OrderTypeTableRowState();
}

class _OrderTypeTableRowState extends State<OrderTypeTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              text: widget.orderType,
              flex: 3,
              isBold: true,
            ),
            _buildCell(
              context,
              text: '${widget.orderCount}',
              flex: 2,
            ),
            _buildCell(
              context,
              text: '${widget.totalRevenue.toStringAsFixed(2)} ج.م',
              flex: 3,
              isRevenue: true,
            ),
            _buildCell(
              context,
              text: '${widget.averageValue.toStringAsFixed(2)} ج.م',
              flex: 3,
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