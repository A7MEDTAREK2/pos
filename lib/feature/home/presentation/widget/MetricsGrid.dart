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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.blackOpacity10,
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
                  style: TxtStyle.labelLarge.copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // 🎯 تحول سلس للرقم عند التحديث اللحظي
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Text(
                    value,
                    key: ValueKey<String>(value), // يضمن إرسال التأثير اللحظي فور تغيّر القيمة
                    style: TxtStyle.dashboardValue,
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
                        ? Colorsmanegments.success.withOpacity(0.12)
                        : Colorsmanegments.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Iconss.trendingUp : Iconss.trendingDown,
                        size: 14,
                        color: isPositive
                            ? Colorsmanegments.success
                            : Colorsmanegments.danger,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badgeText!,
                        style: TxtStyle.badgeSmall.copyWith(
                          color: isPositive
                              ? Colorsmanegments.success
                              : Colorsmanegments.danger,
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
                color: Colorsmanegments.textSecondary.withOpacity(0.6),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}