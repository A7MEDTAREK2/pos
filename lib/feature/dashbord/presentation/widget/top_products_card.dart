import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import '../../data/model/top_product_model.dart';
import 'dashboard_card.dart';
import 'section_title.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is DashboardError) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Text(state.message),
              ),
            );
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final products = state.dashboard.topProducts;

          if (products.isEmpty) {
            return const SizedBox(
              height: 250,
              child: Center(
                child: Text("لا توجد بيانات"),
              ),
            );
          }

          final maxSales = products.first.quantity == 0
              ? 1
              : products.first.quantity.toDouble();

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
        },
      ),
    );
  }

  Widget _buildProductItem(
      TopProductModel product,
      double progress,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fastfood,
                size: 20,
                color: const Color(0xFF2563EB).withOpacity(.5),
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
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      '${product.quantity} مبيعات',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      '${product.total.toStringAsFixed(0)} ج.م',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE5E7EB),
                    color: const Color(0xFF2563EB),
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