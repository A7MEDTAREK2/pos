// lib/feature/reports/customer_report/presentation/widgets/customer_table_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerTableHeader extends StatelessWidget {
  const CustomerTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          _headerCell('#', flex: 1),
          _headerCell('اسم العميل', flex: 3),
          _headerCell('رقم الهاتف', flex: 2),
          _headerCell('عدد الطلبات', flex: 2),
          _headerCell('إجمالي المشتريات', flex: 3),
          _headerCell('آخر عملية شراء', flex: 2),
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}