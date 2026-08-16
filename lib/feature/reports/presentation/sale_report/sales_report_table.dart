// lib/feature/reports/sale_report/sales_report_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:home/feature/reports/logic/sale_report_cubit.dart';
import 'package:home/feature/reports/logic/sale_report_state.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_details_dialog.dart';

import 'package:home/feature/reports/presentation/sale_report/sales_table_header.dart';
import 'package:home/feature/reports/presentation/sale_report/sales_table_row.dart';

import '../../../../core/service/printing/mapper/sale_to_order_mapper.dart';
import '../../../../core/service/printing/printing_manager.dart';
import '../../../sale/logic/sale_details_cubit.dart';
import '../../logic/SaleDetailsCubit .dart';
import '../../logic/sale_details_state.dart';

class SalesReportTable extends StatelessWidget {
  const SalesReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.04),
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
            Container(height: 1, color: colorScheme.outlineVariant),

            // ====== Rows ======
            Expanded(
              child: BlocBuilder<ReportCubit, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReportsError) {
                    final errorState = state;
                    return Center(
                      child: Text(
                        errorState.message,
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }

                  if (state is ReportsLoaded) {
                    if (state.sales.isEmpty) {
                      return Center(
                        child: Text(
                          "لا توجد مبيعات",
                          style: theme.textTheme.bodyMedium,
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
                            final cubit = context.read<SaleDetailssCubit>();
                            await cubit.loadSale(sale.saleId);
                            if (!context.mounted) return;
                            final state = cubit.state;
                            if (state is SaleDetailsLoaded) {
                              SaleDetailsDialog.show(context, state.sale);
                            }
                          },
                          onPrint: () async {
                            final cubit = context.read<SaleDetailssCubit>();
                            await cubit.loadSale(sale.saleId);
                            if (!context.mounted) return;
                            final state = cubit.state;
                            if (state is SaleDetailsLoaded) {
                              final order = SaleToOrderMapper.map(state.sale);
                              await PrintingManager.instance.printReceipt(order);
                            }
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
                color: colorScheme.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant, width: 1),
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
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        );
                      }
                      return Text(
                        'إجمالي النتائج: 0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
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
                            context,
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
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
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
                            context,
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

  Widget _buildPaginationButton(
      BuildContext context, {
        required IconData icon,
        required bool isActive,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? null
              : Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: IconButton(
          onPressed: isActive ? onTap : null,
          icon: Icon(
            icon,
            size: 18,
            color: isActive
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withOpacity(0.4),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ),
    );
  }
}