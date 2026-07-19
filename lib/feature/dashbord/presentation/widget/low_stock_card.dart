import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';
import 'section_title.dart';

class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is DashboardError) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Text(state.message),
              ),
            );
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final products = state.dashboard.lowStockProducts;

          if (products.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Text("لا يوجد منتجات منخفضة المخزون"),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SectionTitle(title: "المخزون المنخفض"),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${products.length} منتج",
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ...products.map(
                    (product) => _buildProductItem(
                  name: product.name,
                  stock: product.quantity,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

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
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isCritical
                  ? const Color(0xFFDC2626).withOpacity(.1)
                  : const Color(0xFFF59E0B).withOpacity(.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "$stock",
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCritical
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFF59E0B),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              name,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.red.withOpacity(.2),
              ),
            ),
            child: Text(
              "⚠️ $stock",
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}