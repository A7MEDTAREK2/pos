// lib/feature/reports/presentation/customer_report/customer_report_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/report/customer_report_cubit.dart';
import '../../../logic/report/customer_report_state.dart';
import 'Customer_Report_Table.dart';


class CustomerReportView extends StatelessWidget {
  const CustomerReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تقرير العملاء",
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "عرض وتحليل بيانات العملاء",
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<CustomerReportCubit, CustomerReportState>(
              builder: (context, state) {
                if (state is CustomerReportLoading) {
                  return _buildLoadingState();
                }
                if (state is CustomerReportError) {
                  return _buildErrorState(state.message, context);
                }
                if (state is CustomerReportLoaded) {
                  if (state.customers.isEmpty) {
                    return _buildEmptyState();
                  }
                  return const CustomerReportTable();
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
              'جاري تحميل العملاء...',
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
              onPressed: () => context.read<CustomerReportCubit>().loadReport(),
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
            Icon(Icons.people_outline, size: 64, color: const Color(0xFF6B7280).withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'لا يوجد عملاء',
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بإضافة عملاء جدد لعرضهم هنا',
              style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}