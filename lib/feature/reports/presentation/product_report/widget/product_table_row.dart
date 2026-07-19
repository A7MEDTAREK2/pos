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
          color: _getRowColor(),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFF1F5F9),
              width: 0.5,
            ),
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.04),
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
              text: widget.index.toString(),
              flex: 1,
              isIndex: true,
            ),

            // ====== Product Name ======
            _buildCell(
              text: widget.productName,
              flex: 4,
              isBold: true,
            ),

            // ====== Sales Count ======
            _buildCell(
              text: '${widget.salesCount}',
              flex: 2,
            ),

            // ====== Total Quantity ======
            _buildCell(
              text: '${widget.totalQuantity}',
              flex: 2,
            ),

            // ====== Total Revenue ======
            _buildCell(
              text: '${widget.totalRevenue.toStringAsFixed(2)} ج.م',
              flex: 3,
              isRevenue: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell({
    required String text,
    int flex = 1,
    bool isBold = false,
    bool isIndex = false,
    bool isRevenue = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: isBold || isRevenue ? FontWeight.w600 : FontWeight.w400,
          color: isRevenue
              ? const Color(0xFF16A34A)
              : isIndex
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF111827),
        ),
      ),
    );
  }

  Color _getRowColor() {
    if (_isHovered) {
      return const Color(0xFF2563EB).withOpacity(0.04);
    }
    return widget.isEven
        ? const Color(0xFFFAFBFC)
        : Colors.white;
  }
}