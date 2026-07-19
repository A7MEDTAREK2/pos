// lib/feature/dashboard/presentation/widgets/sales_chart_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sales_chart_model.dart';
import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'package:intl/intl.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        // ====== Loading State ======
        if (state is DashboardLoading) {
          return _buildChartCard(
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2563EB),
              ),
            ),
          );
        }

        // ====== Error State ======
        if (state is DashboardError) {
          return _buildChartCard(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: const Color(0xFFDC2626).withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      context.read<DashboardCubit>().loadDashboard();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        // ====== Success State ======
        if (state is DashboardSuccess) {
          final data = state.dashboard.salesChart;

          if (data.isEmpty) {
            return _buildChartCard(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: const Color(0xFF6B7280).withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد بيانات مبيعات',
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

          final dashboard = state.dashboard;

          final totalSales = dashboard.totalSales;
          final average = _calculateAverage(data);
          final highestPoint = _getHighestPoint(data);

          return _buildChartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== العنوان ======
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تحليل المبيعات',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'يعرض أداء المبيعات خلال الفترة المحددة',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ====== الرسم البياني ======
                SizedBox(
                  height: 280,
                  child: _buildLineChart(data),
                ),

                const SizedBox(height: 24),

                // ====== البطاقات السفلية ======
                Row(
                  children: [
                    _buildSummaryCard(
                      icon: Icons.attach_money,
                      title: 'إجمالي المبيعات',
                      value: '${_formatNumber(totalSales)} ج.م',
                      color: const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      icon: Icons.trending_up,
                      title: 'متوسط اليوم',
                      value: '${_formatNumber(average)} ج.م',
                      color: const Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      icon: Icons.emoji_events,
                      title: 'أعلى يوم',
                      value: highestPoint == null
                          ? "-"
                          : _formatDateLabel(highestPoint.label),
                      color: const Color(0xFFF59E0B),
                      showIcon: false,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ============================================================
  // Widget: بطاقة الرسم البياني (Container موحد)
  // ============================================================
  Widget _buildChartCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // Widget: الرسم البياني
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
              color: const Color(0xFFE5E7EB),
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
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: const Color(0xFF6B7280),
                      ),
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
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value.amount,
              );
            }).toList(),
            isCurved: true,
            curveSmoothness: 0.4,
            color: const Color(0xFF2563EB),
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF2563EB).withOpacity(0.08),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF2563EB),
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
  // Widget: بطاقة الملخص
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
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
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
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
            if (showIcon) const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
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
  // دوال حسابية
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

  // ============================================================
  // دوال التنسيق
  // ============================================================
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

      // أو لو عايز أسماء الأيام:
      // return DateFormat('EEE', 'ar').format(date);

    } catch (_) {
      return value;
    }
  }
}