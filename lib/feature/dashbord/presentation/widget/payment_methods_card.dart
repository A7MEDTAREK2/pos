// lib/feature/dashboard/presentation/widgets/payment_methods_card.dart

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


class PaymentMethodsCard extends StatelessWidget {
  const PaymentMethodsCard({super.key});

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

          final methods = state.dashboard.paymentMethods;

          if (methods.isEmpty) {
            return _buildEmptyState();
          }

          final totalAmount = methods.fold<double>(
            0,
                (sum, item) => sum + item.total,
          );

          return _buildContent(methods, totalAmount);
        },
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 220,
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
      height: 220,
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
      height: 220,
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
  Widget _buildContent(List<dynamic> methods, double totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'طرق الدفع'),
        const SizedBox(height: 16),
        ...methods.asMap().entries.map(
              (entry) {
            final item = entry.value;
            final percentage = totalAmount == 0 ? 0.0 : item.total / totalAmount;
            return _buildMethodItem(
              name: item.method,
              count: item.count,
              percentage: percentage,
              color: _getColor(entry.key),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // Method Item
  // ============================================================
  Widget _buildMethodItem({
    required String name,
    required int count,
    required double percentage,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TxtStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$count',
                style: TxtStyle.tableRowBold,
              ),
              const SizedBox(width: 12),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: TxtStyle.tableRowBold.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: Colorsmanegments.border,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Helper
  // ============================================================
  Color _getColor(int index) {
    final colors = [
      Colorsmanegments.success,
      Colorsmanegments.primary,
      Colorsmanegments.purple,
      Colorsmanegments.warning,
      Colorsmanegments.danger,
      Colorsmanegments.teal,
    ];
    return colors[index % colors.length];
  }
}