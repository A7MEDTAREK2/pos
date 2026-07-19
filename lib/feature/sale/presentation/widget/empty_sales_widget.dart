// lib/feature/sale/presentation/widget/empty_sales_widget.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class EmptySalesWidget extends StatelessWidget {
  const EmptySalesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.orderEmpty,
            size: 80,
            color: Colorsmanegments.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فواتير',
            style: TxtStyle.emptyTitle.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإتمام عملية بيع لظهور الفواتير هنا',
            style: TxtStyle.emptySubtitle,
          ),
        ],
      ),
    );
  }
}