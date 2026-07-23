// lib/feature/dashboard/presentation/widgets/low_stock_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Dashboard ======
import '../../../setting/pre/widget/section_title.dart';
import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';

class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          }

          if (state is DashboardError) {
            return _buildErrorState(state.message);
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final products = state.dashboard.lowStockProducts;

          if (products.isEmpty) {
            return _buildEmptyState();
          }

          return _buildContent(products);
        },
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          color: Colorsmanegments.primary,
        ),
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          message,
          style: TxtStyle.danger,
        ),
      ),
    );
  }

  // ============================================================
  // Empty State
  // ============================================================
  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          "لا يوجد منتجات منخفضة المخزون",
          style: TxtStyle.bodyMedium,
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================
  Widget _buildContent(List<dynamic> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SectionTitle(title: "المخزون المنخفض"),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colorsmanegments.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${products.length} منتج",
                style: TxtStyle.badgeSmall.copyWith(
                  color: Colorsmanegments.danger,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...products.map((product) => _buildProductItem(
          name: product.name,
          stock: product.quantity,
        )),
      ],
    );
  }

  // ============================================================
  // Product Item
  // ============================================================
  Widget _buildProductItem({
    required String name,
    required int stock,
  }) {
    final isCritical = stock <= 5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCritical
                  ? Colorsmanegments.danger.withOpacity(0.1)
                  : Colorsmanegments.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "$stock",
              style: TxtStyle.tableRowBold.copyWith(
                color: isCritical
                    ? Colorsmanegments.danger
                    : Colorsmanegments.warning,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TxtStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colorsmanegments.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colorsmanegments.danger.withOpacity(0.2),
              ),
            ),
            child: Text(
              "⚠️ $stock",
              style: TxtStyle.badgeSmall.copyWith(
                color: Colorsmanegments.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}