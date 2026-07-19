// lib/feature/reports/stock_report/presentation/widgets/stock_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockTableRow extends StatefulWidget {
  const StockTableRow({
    super.key,
    required this.index,
    required this.productName,
    required this.quantity,
    // required this.costPrice,
    // required this.sellPrice,
    required this.stockValue,
    required this.status,
    required this.isEven,
  });

  final int index;
  final String productName;
  final int quantity;
  // final double costPrice;
  // final double sellPrice;
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
    final isLowStock = widget.status == 'منخفض';
    final isOutOfStock = widget.status == 'نفد';
    final statusColor = isLowStock
        ? const Color(0xFFF59E0B)
        : isOutOfStock
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

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
            _buildCell(
              text: widget.index.toString(),
              flex: 1,
              isIndex: true,
            ),
            _buildCell(
              text: widget.productName,
              flex: 3,
              isBold: true,
            ),
            _buildCell(
              text: '${widget.quantity}',
              flex: 2,
            ),
            // _buildCell(
            //   text: '${widget.costPrice.toStringAsFixed(2)} ج.م',
            //   flex: 2,
            // ),
            // _buildCell(
            //   text: '${widget.sellPrice.toStringAsFixed(2)} ج.م',
            //   flex: 2,
            // ),
            _buildCell(
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
                    style: GoogleFonts.cairo(
                      fontSize: 12,
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