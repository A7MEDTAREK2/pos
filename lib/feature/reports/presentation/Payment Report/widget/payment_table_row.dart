// lib/feature/reports/payment_report/presentation/widgets/payment_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentTableRow extends StatefulWidget {
  const PaymentTableRow({
    super.key,
    required this.index,
    required this.paymentMethod,
    required this.transactionCount,
    required this.totalRevenue,
    required this.averageValue,
    required this.isEven,
  });

  final int index;
  final String paymentMethod;
  final int transactionCount;
  final double totalRevenue;
  final double averageValue;
  final bool isEven;

  @override
  State<PaymentTableRow> createState() => _PaymentTableRowState();
}

class _PaymentTableRowState extends State<PaymentTableRow> {
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
            _buildCell(
              text: widget.index.toString(),
              flex: 1,
              isIndex: true,
            ),
            _buildCell(
              text: widget.paymentMethod,
              flex: 3,
              isBold: true,
            ),
            _buildCell(
              text: '${widget.transactionCount}',
              flex: 2,
            ),
            _buildCell(
              text: '${widget.totalRevenue.toStringAsFixed(2)} ج.م',
              flex: 3,
              isRevenue: true,
            ),
            _buildCell(
              text: '${widget.averageValue.toStringAsFixed(2)} ج.م',
              flex: 3,
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