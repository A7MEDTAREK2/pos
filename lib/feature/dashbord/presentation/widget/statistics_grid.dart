// lib/feature/dashboard/presentation/widgets/statistics_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'statistic_card.dart';

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is! DashboardSuccess) {
          return const Center(
            child: Text("لا توجد بيانات"),
          );
        }

        final dashboard = state.dashboard;

        final statistics = [
          StatisticData(
            icon: Icons.attach_money,
            title: 'إجمالي المبيعات',
            value: _formatCurrency(dashboard.totalSales),
            change: 0,
            color: const Color(0xFF2563EB),
          ),
          StatisticData(
            icon: Icons.receipt_long,
            title: 'عدد الفواتير',
            value: dashboard.totalOrders.toString(),
            change: 0,
            color: const Color(0xFF16A34A),
          ),
          StatisticData(
            icon: Icons.trending_up,
            title: 'متوسط الفاتورة',
            value: _formatCurrency(dashboard.averageOrder),
            change: 0,
            color: const Color(0xFFF59E0B),
          ),
          StatisticData(
            icon: Icons.pie_chart,
            title: 'الأرباح',
            value: _formatCurrency(dashboard.totalProfit),
            change: 0,
            color: const Color(0xFF8B5CF6),
          ),
          StatisticData(
            icon: Icons.people,
            title: 'العملاء',
            value: dashboard.totalCustomers.toString(),
            change: 0,
            color: const Color(0xFFEC4899),
          ),
          StatisticData(
            icon: Icons.inventory_2,
            title: 'المنتجات',
            value: dashboard.totalProducts.toString(),
            change: 0,
            color: const Color(0xFF14B8A6),
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: statistics.length,
          itemBuilder: (context, index) {
            return StatisticCard(
              data: statistics[index],
            );
          },
        );
      },
    );
  }

  static String _formatCurrency(double value) {
    return '${value.toStringAsFixed(0)} ج.م';
  }
}