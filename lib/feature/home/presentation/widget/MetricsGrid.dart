// lib/feature/dashboard/presentation/widgets/metrics_grid.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class MetricsGrid extends StatelessWidget {
  final double todaySales;
  final int invoiceCount;
  final int totalProducts;
  final int totalCustomers;

  const MetricsGrid({
    super.key,
    required this.todaySales,
    required this.invoiceCount,
    required this.totalProducts,
    required this.totalCustomers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: "مبيعات اليوم",
            value: "${todaySales.toStringAsFixed(2)} ج.م",
            icon: Iconss.sales,
            badgeText: "مباشر",
            isPositive: true,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: MetricCard(
            title: "الفواتير",
            value: "$invoiceCount",
            icon: Iconss.receipt,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: MetricCard(
            title: "المنتجات",
            value: "$totalProducts",
            icon: Iconss.product,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: MetricCard(
            title: "العملاء",
            value: "$totalCustomers",
            icon: Iconss.customer,
          ),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? badgeText;
  final bool isPositive;

  const MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    this.badgeText,
    this.isPositive = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 0.5,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Text(
                    value,
                    key: ValueKey<String>(value),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withOpacity(0.12)
                        : Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Iconss.trendingUp : Iconss.trendingDown,
                        size: 14,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badgeText!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 24),

              const SizedBox(height: 16),

              Icon(
                icon,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}