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
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildChartCard(
            child: const Center(
              child: CircularProgressIndicator(
                color: Colorsmanegments.primary,
              ),
            ),
          );
        }

        if (state is DashboardError) {
          return _buildChartCard(
            child: _buildErrorContent(state.message, context),
          );
        }

        if (state is DashboardSuccess) {
          final data = state.dashboard.salesChart;

          if (data.isEmpty) {
            return _buildChartCard(
              child: _buildEmptyContent(),
            );
          }

          final dashboard = state.dashboard;
          final totalSales = dashboard.totalSales;
          final average = _calculateAverage(data);
          final highestPoint = _getHighestPoint(data);

          return _buildChartCard(
            child: _buildContent(data, totalSales, average, highestPoint),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ============================================================
  // Content
  // ============================================================
  Widget _buildContent(
      List<SalesChartModel> data,
      double totalSales,
      double average,
      SalesChartModel? highestPoint,
      ) {
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
                    style: TxtStyle.headerSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'يعرض أداء المبيعات خلال الفترة المحددة',
                    style: TxtStyle.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280,
          child: _buildLineChart(data),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildSummaryCard(
              icon: Iconss.sales,
              title: 'إجمالي المبيعات',
              value: '${_formatNumber(totalSales)} ج.م',
              color: Colorsmanegments.primary,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              icon: Iconss.trendingUp,
              title: 'متوسط اليوم',
              value: '${_formatNumber(average)} ج.م',
              color: Colorsmanegments.success,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              icon: Iconss.event,
              title: 'أعلى يوم',
              value: highestPoint == null
                  ? "-"
                  : _formatDateLabel(highestPoint.label),
              color: Colorsmanegments.warning,
              showIcon: false,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // Widget: Chart Card Container
  // ============================================================
  Widget _buildChartCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // Error Content
  // ============================================================
  Widget _buildErrorContent(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.error,
            size: 48,
            color: Colorsmanegments.danger.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TxtStyle.bodySmall.copyWith(
              color: Colorsmanegments.textSecondary,
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
              color: Colorsmanegments.primary,
            ),
            label: Text(
              'إعادة المحاولة',
              style: TxtStyle.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Empty Content
  // ============================================================
  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.chart,
            size: 48,
            color: Colorsmanegments.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد بيانات مبيعات',
            style: TxtStyle.bodyMedium.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Widget: Line Chart
  // ============================================================
  Widget _buildLineChart(List<SalesChartModel> data) {
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
              color: Colorsmanegments.border,
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
                      style: TxtStyle.labelSmall,
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
                  style: TxtStyle.labelSmall,
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
            color: Colorsmanegments.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colorsmanegments.primary.withOpacity(0.08),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colorsmanegments.card,
                  strokeWidth: 2,
                  strokeColor: Colorsmanegments.primary,
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

  // ============================================================
  // Widget: Summary Card
  // ============================================================
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool showIcon = true,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colorsmanegments.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colorsmanegments.border),
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
                  Text(title, style: TxtStyle.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TxtStyle.totalSmall.copyWith(
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

  // ============================================================
  // Helper Functions
  // ============================================================
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