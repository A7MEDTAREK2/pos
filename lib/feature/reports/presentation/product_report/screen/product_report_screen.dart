// lib/feature/reports/product_report/presentation/screen/orderType_report_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/product_report_cubit.dart';
import '../../../logic/product_report_state.dart';
import '../widget/product_report_table.dart';
import '../widget/product_report_toolbar.dart';
import '../widget/product_report_view.dart';


class ProductReportScreen extends StatelessWidget {
  const ProductReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:  BlocBuilder<ProductReportCubit, ProductReportState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== Toolbar ======
                  ProductReportView(),
                  const SizedBox(height: 24),

                  // ====== Table ======
                  Expanded(
                    child: _buildContent(context, state),
                  ),
                ],
              ),
            );
          },
        ),

    );
  }

  Widget _buildContent(BuildContext context, ProductReportState state) {
    if (state is ProductReportLoading) {
      return _buildLoadingState();
    }

    if (state is ProductReportError) {
      return _buildErrorState(state.message, context);
    }

    if (state is ProductReportLoaded) {
      if (state.products.isEmpty) {
        return _buildEmptyState();
      }
      return const ProductReportTable();
    }

    return const SizedBox();
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF2563EB),
            ),
            SizedBox(height: 16),
            Text(
              'جاري تحميل المنتجات...',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: const Color(0xFFDC2626).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                context.read<ProductReportCubit>().loadReport();
              },
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: const Color(0xFF6B7280).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بإضافة منتجات جديدة لعرضها هنا',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}