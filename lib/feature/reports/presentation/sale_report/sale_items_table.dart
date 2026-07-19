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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // ====== Header ======
          _buildHeader(),

          // ====== Rows ======
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildRow(item, index);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          _headerCell('المنتج', flex: 4),
          _headerCell('الحجم', flex: 2),
          _headerCell('الكمية', flex: 2),
          _headerCell('السعر', flex: 2),
          _headerCell('الإجمالي', flex: 2),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildRow(SaleItemModel item, int index) {
    final isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isEven ? const Color(0xFFFAFBFC) : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        children: [
          _rowCell(item.productName, flex: 4),
          _rowCell(item.sizeName ?? '--', flex: 2),
          _rowCell('${item.quantity}', flex: 2),
          _rowCell('${item.price.toStringAsFixed(2)} ج.م', flex: 2),
          _rowCell(
            '${(item.price * item.quantity).toStringAsFixed(2)} ج.م',
            flex: 2,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _rowCell(String text, {int flex = 1, bool isTotal = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? const Color(0xFF16A34A) : const Color(0xFF111827),
        ),
      ),
    );
  }
}