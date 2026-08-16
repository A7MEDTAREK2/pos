// lib/feature/sale/presentation/widget/sales_stats_card.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../logic/sale_state.dart';

class SalesStatsCard extends StatelessWidget {
  final SalesHistorySuccess state;

  const SalesStatsCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            context,
            Iconss.order,
            "الطلبات",
            "${state.totalOrders}",
          ),
          _divider(context),
          _item(
            context,
            Iconss.sales,
            "الإجمالي",
            "${state.totalSales.toStringAsFixed(2)} ج.م",
          ),
          _divider(context),
          _item(
            context,
            Iconss.trendingUp,
            "المتوسط",
            "${state.averageOrderValue.toStringAsFixed(2)} ج.م",
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 1,
      height: 40,
      color: colorScheme.onPrimary.withOpacity(0.3),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: colorScheme.onPrimary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}