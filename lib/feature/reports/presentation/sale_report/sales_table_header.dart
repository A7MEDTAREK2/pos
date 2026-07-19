import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesTableHeader extends StatelessWidget {
  const SalesTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: const Row(
        children: [
          _HeaderCell("م"),
          _HeaderCell("رقم الفاتورة", flex: 2),
          _HeaderCell("العميل", flex: 3),
          _HeaderCell("نوع الطلب", flex: 2),
          _HeaderCell("الدفع", flex: 2),
          _HeaderCell("الإجمالي", flex: 2),
          _HeaderCell("التاريخ", flex: 2),
          _HeaderCell("الإجراءات", flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const _HeaderCell(
      this.title, {
        this.flex = 1,
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }
}