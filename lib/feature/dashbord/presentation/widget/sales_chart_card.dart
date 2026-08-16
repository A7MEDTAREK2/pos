// lib/feature/dashboard/presentation/widgets/sales_chart_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Dashboard ======
import '../../data/model/sales_chart_model.dart';
import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildChartCard(
            context,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is DashboardError) {
          return _buildChartCard(
            context,
            child: _buildErrorContent(context, state.message),
          );
        }

        if (state is DashboardSuccess) {
          final data = state.dashboard.salesChart;

          if (data.isEmpty) {
            return _buildChartCard(
              context,
              child: _buildEmptyContent(context),
            );
          }

          final dashboard = state.dashboard;
          final totalSales = dashboard.totalSales;
          final average = _calculateAverage(data);
          final highestPoint = _getHighestPoint(data);

          return _buildChartCard(
            context,
            child: _buildContent(
              context,
              data,
              totalSales,
              average,
              highestPoint,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildContent(
      BuildContext context,
      List<SalesChartModel> data,
      double totalSales,
      double average,
      SalesChartModel? highestPoint,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحليل المبيعات',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'يعرض أداء المبيعات خلال الفترة المحددة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280,
          child: _buildLineChart(context, data),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildSummaryCard(
              context,
              icon: Iconss.sales,
              title: 'إجمالي المبيعات',
              value: '${_formatNumber(totalSales)} ج.م',
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              context,
              icon: Iconss.trendingUp,
              title: 'متوسط اليوم',
              value: '${_formatNumber(average)} ج.م',
              color: Colors.green,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              context,
              icon: Iconss.event,
              title: 'أعلى يوم',
              value: highestPoint == null
                  ? "-"
                  : _formatDateLabel(highestPoint.label),
              color: Colors.amber,
              showIcon: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.error,
            size: 48,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              context.read<DashboardCubit>().loadDashboard();
            },
            icon: Icon(
              Iconss.refresh,
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text(
              'إعادة المحاولة',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.chart,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد بيانات مبيعات',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(BuildContext context, List<SalesChartModel> data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final maxValue = data.isEmpty
        ? 1000
        : data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colorScheme.outlineVariant,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _formatDateLabel(data[index].label),
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxisValue(value),
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.amount);
            }).toList(),
            isCurved: true,
            curveSmoothness: 0.4,
            color: colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.primary.withOpacity(0.08),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: colorScheme.surface,
                  strokeWidth: 2,
                  strokeColor: colorScheme.primary,
                );
              },
            ),
          ),
        ],
        minY: 0,
        maxY: maxValue * 1.2,
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
        bool showIcon = true,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            if (showIcon)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            if (showIcon) const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Functions
  double _calculateTotal(List<SalesChartModel> data) {
    return data.fold(0, (sum, item) => sum + item.amount);
  }

  double _calculateAverage(List<SalesChartModel> data) {
    if (data.isEmpty) return 0;
    return _calculateTotal(data) / data.length;
  }

  SalesChartModel? _getHighestPoint(List<SalesChartModel> data) {
    if (data.isEmpty) return null;
    return data.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}م';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}ألف';
    }
    return value.toStringAsFixed(0);
  }

  String _formatYAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}م';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}أ';
    }
    return value.toStringAsFixed(0);
  }

  String _formatDateLabel(String value) {
    try {
      final date = DateTime.parse(value);
      return DateFormat('dd/MM').format(date);
    } catch (_) {
      return value;
    }
  }
}