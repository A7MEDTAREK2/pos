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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState(context);
          }

          if (state is DashboardError) {
            return _buildErrorState(context, state.message);
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final sales = state.dashboard.recentSales;

          if (sales.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildContent(context, sales);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 250,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          "لا توجد فواتير",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<dynamic> sales) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'آخر الفواتير',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            headingRowColor: WidgetStateProperty.all(
              colorScheme.background,
            ),
            headingTextStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: theme.textTheme.bodyMedium,
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
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(sale.customerName),
                  ),
                  DataCell(
                    Text(
                      '${sale.total.toStringAsFixed(2)} ج.م',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
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