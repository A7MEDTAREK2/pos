// lib/feature/reports/presentation/stock_report/stock_report_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/Stock%20Report/widget/stock_Report_Table.dart';

import '../../../logic/report/stock_report_cubit.dart';
import '../../../logic/report/stock_report_state.dart';


class StockReportView extends StatelessWidget {
  const StockReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تقرير المخزون",
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "عرض وتحليل مخزون المنتجات",
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<StockReportCubit, StockReportState>(
              builder: (context, state) {
                if (state is StockReportLoading) {
                  return _buildLoadingState();
                }
                if (state is StockReportError) {
                  return _buildErrorState(state.message, context);
                }
                if (state is StockReportLoaded) {
                  if (state.products.isEmpty) {
                    return _buildEmptyState();
                  }
                  return const StockReportTable();
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2563EB)),
            SizedBox(height: 16),
            Text(
              'جاري تحميل المخزون...',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: const Color(0xFFDC2626).withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.read<StockReportCubit>().loadReport(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warehouse_outlined, size: 64, color: const Color(0xFF6B7280).withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات في المخزون',
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بإضافة منتجات للمخزون لعرضها هنا',
              style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}