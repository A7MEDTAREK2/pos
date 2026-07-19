import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';
import 'section_title.dart';

class OrderTypesCard extends StatelessWidget {
  const OrderTypesCard({super.key});

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

          final types = state.dashboard.orderTypes;

          if (types.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Text("لا توجد بيانات"),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'أنواع الطلبات'),
              const SizedBox(height: 16),

              ...types.map(
                    (type) => _buildTypeItem(
                      name: type.type,
                  count: type.count,
                  color: _getOrderTypeColor(type.type),
                  icon: _getOrderTypeIcon(type.type),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

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
              color: color.withOpacity(.1),
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
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count طلب',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }


  }

IconData _getOrderTypeIcon(String type) {
  switch (type) {
    case "تيك أواي":
      return Icons.takeout_dining;

    case "داخل المطعم":
      return Icons.table_restaurant;

    case "دليفري":
      return Icons.delivery_dining;

    default:
      return Icons.receipt_long;
  }

  }

Color _getOrderTypeColor(String type) {
  switch (type) {
    case "تيك أواي":
      return const Color(0xFFF59E0B);

    case "داخل المطعم":
      return const Color(0xFF16A34A);

    case "دليفري":
      return const Color(0xFF2563EB);

    default:
      return Colors.grey;
  }
}
