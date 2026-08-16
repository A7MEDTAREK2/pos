// lib/feature/dashboard/presentation/widgets/top_products_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Dashboard ======
import '../../../setting/pre/widget/section_title.dart';
import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import '../../data/model/top_product_model.dart';
import 'dashboard_card.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key});

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

          final products = state.dashboard.topProducts;

          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          final maxSales = products.first.quantity == 0
              ? 1.0
              : products.first.quantity.toDouble();

          return _buildContent(context, products, maxSales);
        },
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 250,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
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

  // ============================================================
  // Empty State
  // ============================================================
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          "لا توجد بيانات",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================
  Widget _buildContent(
      BuildContext context,
      List<TopProductModel> products,
      double maxSales,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أفضل المنتجات',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...products.map(
              (product) => _buildProductItem(
            context,
            product,
            product.quantity / maxSales,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Product Item
  // ============================================================
  Widget _buildProductItem(
      BuildContext context,
      TopProductModel product,
      double progress,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // ====== Product Icon ======
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Center(
              child: Icon(
                Iconss.food,
                size: 20,
                color: colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ====== Product Info ======
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${product.quantity} مبيعات',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${product.total.toStringAsFixed(0)} ج.م',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // ====== Progress Bar ======
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1).toDouble(),
                    minHeight: 4,
                    backgroundColor: colorScheme.outlineVariant,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}