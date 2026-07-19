// lib/feature/reports/sale_report/sales_table_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/sale_report/payment_method_badge.dart';
import 'order_type_badge.dart';

class SalesTableRow extends StatefulWidget {
  const SalesTableRow({
    super.key,
    required this.index,
    required this.invoiceNumber,
    required this.customerName,
    required this.orderType,
    required this.paymentMethod,
    required this.total,
    required this.date,
    required this.isEven,
    this.onView,
    this.onPrint,
  });

  final int index;
  final String invoiceNumber;
  final String customerName;
  final String orderType;
  final String paymentMethod;
  final String total;
  final String date;
  final bool isEven;
  final VoidCallback? onView;
  final VoidCallback? onPrint;

  @override
  State<SalesTableRow> createState() => _SalesTableRowState();
}

class _SalesTableRowState extends State<SalesTableRow> {
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

            // ====== Invoice Number ======
            _buildCell(
              text: widget.invoiceNumber,
              flex: 2,
              isBold: true,
            ),

            // ====== Customer Name ======
            _buildCell(
              text: widget.customerName,
              flex: 3,
            ),

            // ====== Order Type ======
            Expanded(
              flex: 2,
              child: Center(
                child: OrderTypeBadge(
                  type: widget.orderType,
                ),
              ),
            ),

            // ====== Payment Method ======
            Expanded(
              flex: 2,
              child: Center(
                child: PaymentMethodBadge(
                  method: widget.paymentMethod,
                ),
              ),
            ),

            // ====== Total ======
            _buildCell(
              text: widget.total,
              flex: 2,
              isTotal: true,
            ),

            // ====== Date ======
            _buildCell(
              text: widget.date,
              flex: 2,
            ),

            // ====== Actions ======
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.visibility_outlined,
                    tooltip: 'عرض التفاصيل',
                    color: const Color(0xFF2563EB),
                    onTap: widget.onView,
                  ),
                  const SizedBox(width: 2),
                  _buildActionButton(
                    icon: Icons.print_outlined,
                    tooltip: 'طباعة الفاتورة',
                    color: const Color(0xFF6B7280),
                    onTap: widget.onPrint,
                  ),
                ],
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
    bool isTotal = false,
    bool isIndex = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: isBold || isTotal ? FontWeight.w600 : FontWeight.w400,
          color: isTotal
              ? const Color(0xFF16A34A)
              : isIndex
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isHovered ? color.withOpacity(0.08) : Colors.transparent,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 17,
            color: _isHovered ? color : const Color(0xFF9CA3AF),
          ),
          tooltip: tooltip,
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
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