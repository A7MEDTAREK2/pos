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

          final products = state.dashboard.topProducts;

          if (products.isEmpty) {
            return _buildEmptyState();
          }

          // 🌟 تم تعديل القيمة 1 إلى 1.0 لضمان توافق الأنواع كـ double
          final maxSales = products.first.quantity == 0
              ? 1.0
              : products.first.quantity.toDouble();

          return _buildContent(products, maxSales);
        },
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 250,
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
      height: 250,
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
      height: 250,
      child: Center(
        child: Text(
          "لا توجد بيانات",
          style: TxtStyle.bodyMedium,
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================
  Widget _buildContent(List<TopProductModel> products, double maxSales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'أفضل المنتجات'),
        const SizedBox(height: 16),
        ...products.map(
              (product) => _buildProductItem(
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
  Widget _buildProductItem(TopProductModel product, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colorsmanegments.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colorsmanegments.border),
            ),
            child: Center(
              child: Icon(
                Iconss.food,
                size: 20,
                color: Colorsmanegments.primary.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${product.quantity} مبيعات',
                      style: TxtStyle.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${product.total.toStringAsFixed(0)} ج.م',
                      style: TxtStyle.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colorsmanegments.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    // 🌟 تم إضافة .toDouble() هنا لمنع خطأ اختلاف الأنواع مع num
                    value: progress.clamp(0, 1).toDouble(),
                    minHeight: 4,
                    backgroundColor: Colorsmanegments.border,
                    color: Colorsmanegments.primary,
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