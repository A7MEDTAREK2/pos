// lib/feature/dashboard/presentation/widgets/statistic_card.dart

import 'package:flutter/cupertino.dart';

import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class StatisticData {
  final IconData icon;
  final String title;
  final String value;
  final double change;
  final Color color;

  StatisticData({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.color,
  });
}

class StatisticCard extends StatelessWidget {
  final StatisticData data;

  const StatisticCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isPositive = data.change >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  data.icon,
                  size: 18,
                  color: data.color,
                ),
              ),
              const Spacer(),
              if (data.change != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colorsmanegments.success.withOpacity(0.1)
                        : Colorsmanegments.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive
                            ? Iconss.trendingUp
                            : Iconss.trendingDown,
                        size: 10,
                        color: isPositive
                            ? Colorsmanegments.success
                            : Colorsmanegments.danger,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${isPositive ? '+' : ''}${data.change.toStringAsFixed(1)}%',
                        style: TxtStyle.dashboardChange.copyWith(
                          color: isPositive
                              ? Colorsmanegments.success
                              : Colorsmanegments.danger,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: TxtStyle.dashboardValue,
              ),
              const SizedBox(height: 2),
              Text(
                data.title,
                style: TxtStyle.dashboardTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}