// lib/feature/reports/sale_report/sales_report_table.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:home/feature/reports/logic/sale_report_cubit.dart';
import 'package:home/feature/reports/logic/sale_report_state.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_details_dialog.dart';

import 'package:home/feature/reports/presentation/sale_report/sales_table_header.dart';
import 'package:home/feature/reports/presentation/sale_report/sales_table_row.dart';

import '../../../sale/logic/sale_details_cubit.dart';
import '../../logic/SaleDetailsCubit .dart';
import '../../logic/sale_details_state.dart';

class SalesReportTable extends StatelessWidget {
  const SalesReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ====== Header ======
            const SalesTableHeader(),

            // ====== Divider ======
            Container(height: 1, color: const Color(0xFFE5E7EB)),

            // ====== Rows ======
            Expanded(
              child: BlocBuilder<ReportCubit, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReportsError) {
                    final errorState = state;

                    return Center(child: Text(errorState.message));
                  }

                  if (state is ReportsLoaded) {
                    if (state.sales.isEmpty) {
                      return Center(
                        child: Text(
                          "لا توجد مبيعات",
                          style: GoogleFonts.cairo(),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.sales.length,
                      itemBuilder: (context, index) {
                        final sale = state.sales[index];

                        String orderType;

                        switch (sale.orderType) {
                          case 0:
                            orderType = "تيك أواي";
                            break;

                          case 1:
                            orderType = "داخل المطعم";
                            break;

                          case 2:
                            orderType = "دليفري";
                            break;

                          default:
                            orderType = "-";
                        }
                        return SalesTableRow(
                          onView: () async {
                            debugPrint("VIEW CLICKED");
                            final cubit = context.read<SaleDetailssCubit>();

                            await cubit.loadSale(sale.saleId);

                            if (!context.mounted) return;

                            final state = cubit.state;

                            if (state is SaleDetailsLoaded) {
                              SaleDetailsDialog.show(
                                context,
                                state.sale,
                              );
                            }
                          },

                          onPrint: () {
                            // هنربطه بالطباعة بعد شوية
                          },

                          index: index + 1,
                          invoiceNumber: "#${sale.orderNumber}",
                          customerName: sale.customerName,
                          orderType: orderType,
                          paymentMethod: sale.paymentMethod,
                          total: "${sale.total.toStringAsFixed(2)} ج.م",
                          date: sale.createdAt.toString().split(" ").first,
                          isEven: index.isEven,
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            // ====== Footer ======
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ====== Total Count ======
                  BlocBuilder<ReportCubit, ReportsState>(
                    builder: (context, state) {
                      if (state is ReportsLoaded) {
                        final cubit = context.read<ReportCubit>();

                        return Text(
                          'إجمالي النتائج: ${cubit.totalCount}',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: const Color(0xFF6B7280),
                          ),
                        );
                      }

                      return Text(
                        'إجمالي النتائج: 0',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: const Color(0xFF6B7280),
                        ),
                      );
                    },
                  ),

                  // ====== Pagination ======
                  Row(
                    children: [
                      BlocBuilder<ReportCubit, ReportsState>(
                        builder: (context, state) {
                          final cubit = context.read<ReportCubit>();

                          return _buildPaginationButton(
                            icon: Icons.chevron_left,
                            isActive: cubit.page > 0,
                            onTap: cubit.page > 0
                                ? () => cubit.previousPage()
                                : null,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      BlocBuilder<ReportCubit, ReportsState>(
                        builder: (context, state) {
                          final cubit = context.read<ReportCubit>();

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'الصفحة ${cubit.page + 1} من ${cubit.totalPages == 0 ? 1 : cubit.totalPages}',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      BlocBuilder<ReportCubit, ReportsState>(
                        builder: (context, state) {
                          final cubit = context.read<ReportCubit>();

                          return _buildPaginationButton(
                            icon: Icons.chevron_right,
                            isActive: cubit.page < cubit.totalPages - 1,
                            onTap: cubit.page < cubit.totalPages - 1
                                ? () => cubit.nextPage()
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Pagination Button
  // ============================================================
  Widget _buildPaginationButton({
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: IconButton(
          onPressed: isActive ? onTap : null,
          icon: Icon(
            icon,
            size: 18,
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Pagination Number
  // ============================================================
  Widget _buildPaginationNumber(String number, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? null
              : Border.all(color: Colors.transparent, width: 1),
        ),
        child: Center(
          child: Text(
            number,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
