// lib/feature/reports/presentation/payment_report/payment_report_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/Payment%20Report/widget/payment_Report_Table.dart';
import '../../../logic/report/payment_report_cubit.dart';
import '../../../logic/report/payment_report_state.dart';


class PaymentReportView extends StatelessWidget {
  const PaymentReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تقرير طرق الدفع",
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "عرض وتحليل طرق الدفع",
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<PaymentReportCubit, PaymentReportState>(
              builder: (context, state) {
                if (state is PaymentReportLoading) {
                  return _buildLoadingState();
                }
                if (state is PaymentReportError) {
                  return _buildErrorState(state.message, context);
                }
                if (state is PaymentReportLoaded) {
                  if (state.payments.isEmpty) {
                    return _buildEmptyState();
                  }
                  return const PaymentReportTable();
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
              'جاري تحميل بيانات الدفع...',
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
              onPressed: () => context.read<PaymentReportCubit>().loadReport(),
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
            Icon(Icons.payment_outlined, size: 64, color: const Color(0xFF6B7280).withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'لا توجد بيانات دفع',
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بإتمام عمليات شراء لعرض بيانات الدفع',
              style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}