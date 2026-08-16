// lib/feature/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ====== Dashboard Widgets ======
import '../../../reports/data/data_source/local_data_source.dart';
import '../../../reports/data/repo/local_rapo.dart';
import '../../../reports/logic/sale_report_cubit.dart';
import '../../../reports/presentation/widgets/reports_nav.dart';
import '../../../reports/reports_screen.dart';
import '../../logic/dash_cubit.dart';
import '../widget/dashboard_appbar.dart';
import '../../../../core/widgets/date_filter.dart';
import '../widget/low_stock_card.dart';
import '../widget/order_types_card.dart';
import '../widget/payment_methods_card.dart';
import '../widget/recent_sales_card.dart';
import '../widget/sales_chart_card.dart';
import '../widget/statistics_grid.dart';
import '../widget/top_products_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: CustomScrollView(
          slivers: [
            // ====== AppBar ======
            const SliverToBoxAdapter(
              child: DashboardAppBar(),
            ),

            // ====== المحتوى ======
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // ====== Row: DateFilter + Reports Button ======
                  Row(
                    children: [
                      DateFilter(
                        onDateChanged: (from, to) {
                          context.read<DashboardCubit>().changeDateRange(
                            from: from,
                            to: to,
                          );
                        },
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 1,
                        child: DetailedReportsButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => ReportCubit(
                                    ReportsRepositoryImpl(
                                      localDataSource: ReportsLocalDataSourceImpl(),
                                    ),
                                  )..loadSalesReport(),
                                  child: const ReportsScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ====== Statistics Grid ======
                  const StatisticsGrid(),

                  const SizedBox(height: 24),

                  // ====== Sales Chart ======
                  const SalesChartCard(),

                  const SizedBox(height: 24),

                  // ====== Row: Top Products + Quick Actions ======
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: const TopProductsCard(),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ====== Row: Recent Sales + Order Types ======
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: const RecentSalesCard(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const OrderTypesCard(),
                            const SizedBox(height: 20),
                            const PaymentMethodsCard(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ====== Low Stock ======
                  const LowStockCard(),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}