// lib/feature/dashboard/presentation/widgets/recent_sales_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Dashboard ======
import '../../../setting/pre/widget/section_title.dart';
import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';


class RecentSalesCard extends StatelessWidget {
  const RecentSalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          }

          if (state is DashboardError) {
            return _buildErrorState(state.message);
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final sales = state.dashboard.recentSales;

          if (sales.isEmpty) {
            return _buildEmptyState();
          }

          return _buildContent(sales);
        },
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 250,
      child: Center(
        child: CircularProgressIndicator(
          color: Colorsmanegments.primary,
        ),
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          message,
          style: TxtStyle.danger,
        ),
      ),
    );
  }

  // ============================================================
  // Empty State
  // ============================================================
  Widget _buildEmptyState() {
    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          "لا توجد فواتير",
          style: TxtStyle.bodyMedium,
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================
  Widget _buildContent(List<dynamic> sales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'آخر الفواتير'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            headingRowColor: WidgetStateProperty.all(
              Colorsmanegments.background,
            ),
            headingTextStyle: TxtStyle.tableHeader,
            dataTextStyle: TxtStyle.tableRow,
            columns: const [
              DataColumn(label: Text('رقم الفاتورة')),
              DataColumn(label: Text('العميل')),
              DataColumn(label: Text('الإجمالي')),
              DataColumn(label: Text('طريقة الدفع')),
            ],
            rows: sales.map((sale) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '#${sale.orderNumber}',
                      style: TxtStyle.tableRowBold,
                    ),
                  ),
                  DataCell(
                    Text(sale.customerName),
                  ),
                  DataCell(
                    Text(
                      '${sale.total.toStringAsFixed(2)} ج.م',
                      style: TxtStyle.tableRowBold.copyWith(
                        color: Colorsmanegments.success,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(sale.paymentMethod),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}