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

          final types = state.dashboard.orderTypes;

          if (types.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildContent(context, types);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 200,
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 200,
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

  Widget _buildContent(BuildContext context, List<dynamic> types) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أنواع الطلبات',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...types.map((type) => _buildTypeItem(
          context,
          name: type.type,
          count: type.count,
          color: _getOrderTypeColor(type.type),
          icon: _getOrderTypeIcon(type.type),
        )),
      ],
    );
  }

  Widget _buildTypeItem(
      BuildContext context, {
        required String name,
        required int count,
        required Color color,
        required IconData icon,
      }) {
    final theme = Theme.of(context);

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
              style: theme.textTheme.bodyMedium?.copyWith(
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
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        return Colors.amber;
      case "داخل المطعم":
        return Colors.green;
      case "دليفري":
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }
}