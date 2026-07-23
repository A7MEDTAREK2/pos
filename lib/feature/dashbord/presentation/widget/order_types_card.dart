// lib/feature/dashboard/presentation/widgets/order_types_card.dart

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
import 'dashboard_card.dart';

class OrderTypesCard extends StatelessWidget {
  const OrderTypesCard({super.key});

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

          final types = state.dashboard.orderTypes;

          if (types.isEmpty) {
            return _buildEmptyState();
          }

          return _buildContent(types);
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
    return  SizedBox(
      height: 200,
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
  Widget _buildContent(List<dynamic> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'أنواع الطلبات'),
        const SizedBox(height: 16),
        ...types.map((type) => _buildTypeItem(
          name: type.type,
          count: type.count,
          color: _getOrderTypeColor(type.type),
          icon: _getOrderTypeIcon(type.type),
        )),
      ],
    );
  }

  // ============================================================
  // Type Item
  // ============================================================
  Widget _buildTypeItem({
    required String name,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TxtStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count طلب',
              style: TxtStyle.badgeSmall.copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Helper Functions
  // ============================================================
  IconData _getOrderTypeIcon(String type) {
    switch (type) {
      case "تيك أواي":
        return Iconss.takeaway;
      case "داخل المطعم":
        return Iconss.tableRestaurant;
      case "دليفري":
        return Iconss.delivery;
      default:
        return Iconss.receipt;
    }
  }

  Color _getOrderTypeColor(String type) {
    switch (type) {
      case "تيك أواي":
        return Colorsmanegments.warning;
      case "داخل المطعم":
        return Colorsmanegments.success;
      case "دليفري":
        return Colorsmanegments.primary;
      default:
        return Colorsmanegments.grey;
    }
  }
}