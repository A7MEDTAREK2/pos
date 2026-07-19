import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';
import 'section_title.dart';

class PaymentMethodsCard extends StatelessWidget {
  const PaymentMethodsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is DashboardError) {
            return SizedBox(
              height: 220,
              child: Center(
                child: Text(state.message),
              ),
            );
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final methods = state.dashboard.paymentMethods;

          if (methods.isEmpty) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: Text("لا توجد بيانات"),
              ),
            );
          }

          final totalAmount = methods.fold<double>(
            0,
                (sum, item) => sum + item.total,
          );


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'طرق الدفع'),
              const SizedBox(height: 16),

              ...methods.asMap().entries.map(
                    (entry) {
                  final item = entry.value;

                  final percentage = totalAmount == 0
                      ? 0.0
                      : item.total / totalAmount;

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
        },
      ),
    );
  }

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
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),

              const Spacer(),

              Text(
                '$count',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
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
              backgroundColor: const Color(0xFFE5E7EB),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFF16A34A),
      Color(0xFF2563EB),
      Color(0xFF8B5CF6),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
      Color(0xFF06B6D4),
    ];

    return colors[index % colors.length];
  }
}