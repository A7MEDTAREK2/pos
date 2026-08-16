// lib/feature/reports/product_report/presentation/widgets/customer_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductTableRow extends StatefulWidget {
  const ProductTableRow({
    super.key,
    required this.index,
    required this.productName,
    required this.salesCount,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.isEven,
  });

  final int index;
  final String productName;
  final int salesCount;
  final int totalQuantity;
  final double totalRevenue;
  final bool isEven;

  @override
  State<ProductTableRow> createState() => _ProductTableRowState();
}

class _ProductTableRowState extends State<ProductTableRow> {
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
            // ====== Index ======
            _buildCell(
              context,
              text: widget.index.toString(),
              flex: 1,
              isIndex: true,
            ),

            // ====== Product Name ======
            _buildCell(
              context,
              text: widget.productName,
              flex: 4,
              isBold: true,
            ),

            // ====== Sales Count ======
            _buildCell(
              context,
              text: '${widget.salesCount}',
              flex: 2,
            ),

            // ====== Total Quantity ======
            _buildCell(
              context,
              text: '${widget.totalQuantity}',
              flex: 2,
            ),

            // ====== Total Revenue ======
            _buildCell(
              context,
              text: '${widget.totalRevenue.toStringAsFixed(2)} ج.م',
              flex: 3,
              isRevenue: true,
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