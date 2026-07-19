// lib/feature/reports/customer_report/presentation/widgets/customer_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomerTableRow extends StatefulWidget {
  const CustomerTableRow({
    super.key,
    required this.index,
    required this.customerName,
    required this.phone,
    required this.orderCount,
    required this.totalPurchases,
    required this.lastPurchase,
    required this.isEven,
  });

  final int index;
  final String customerName;
  final String phone;
  final int orderCount;
  final double totalPurchases;
  final String lastPurchase;
  final bool isEven;

  @override
  State<CustomerTableRow> createState() => _CustomerTableRowState();
}

class _CustomerTableRowState extends State<CustomerTableRow> {
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
              text: widget.customerName,
              flex: 3,
              isBold: true,
            ),
            _buildCell(
              text: widget.phone,
              flex: 2,
            ),
            _buildCell(
              text: '${widget.orderCount}',
              flex: 2,
            ),
            _buildCell(
              text: '${widget.totalPurchases.toStringAsFixed(2)} ج.م',
              flex: 3,
              isRevenue: true,
            ),
            _buildCell(
              text: widget.lastPurchase.isEmpty
                  ? "-"
                  : DateFormat(
                'dd/MM/yyyy - hh:mm a',
              ).format(DateTime.parse(widget.lastPurchase)),
              flex: 2,
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