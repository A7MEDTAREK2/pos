// lib/feature/reports/product_report/presentation/widgets/product_report_toolbar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../logic/product_report_cubit.dart';

class ProductReportToolbar extends StatelessWidget {
  const ProductReportToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ====== Search Field ======
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                textDirection: TextDirection.rtl,
                onChanged: (value) {
                  context.read<ProductReportCubit>().searchReport(value);
                },
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المنتج...',
                  hintStyle: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF9CA3AF),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ====== PDF Button ======
          _buildToolButton(
            icon: Icons.picture_as_pdf,
            label: 'PDF',
            color: const Color(0xFFDC2626),
            onPressed: () {
              // Export PDF
            },
          ),

          const SizedBox(width: 8),

          // ====== Excel Button ======
          _buildToolButton(
            icon: Icons.grid_on,
            label: 'Excel',
            color: const Color(0xFF16A34A),
            onPressed: () {
              // Export Excel
            },
          ),

          const SizedBox(width: 8),

          // ====== Print Button ======
          _buildToolButton(
            icon: Icons.print,
            label: 'طباعة',
            color: const Color(0xFF2563EB),
            isPrimary: true,
            onPressed: () {
              // Print
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: isPrimary
          ? ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      )
          : OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: color.withOpacity(0.3)),
          elevation: 0,
        ),
      ),
    );
  }
}