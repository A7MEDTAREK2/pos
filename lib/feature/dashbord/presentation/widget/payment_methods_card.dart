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

          final methods = state.dashboard.paymentMethods;

          if (methods.isEmpty) {
            return _buildEmptyState(context);
          }

          final totalAmount = methods.fold<double>(
            0,
                (sum, item) => sum + item.total,
          );

          return _buildContent(context, methods, totalAmount);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 220,
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
      height: 220,
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

  Widget _buildContent(
      BuildContext context,
      List<dynamic> methods,
      double totalAmount,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طرق الدفع',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...methods.asMap().entries.map(
              (entry) {
            final item = entry.value;
            final percentage = totalAmount == 0 ? 0.0 : item.total / totalAmount;
            return _buildMethodItem(
              context,
              name: item.method,
              count: item.count,
              percentage: percentage,
              color: _getColor(entry.key, colorScheme),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMethodItem(
      BuildContext context, {
        required String name,
        required int count,
        required double percentage,
        required Color color,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$count',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
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
              backgroundColor: colorScheme.outlineVariant,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index, ColorScheme colorScheme) {
    final colors = [
      Colors.green,
      colorScheme.primary,
      Colors.purple,
      Colors.amber,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}