// lib/feature/dashboard/presentation/components/dashboard_card.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final double padding;

  const DashboardCard({
    super.key,
    required this.child,
    this.padding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}