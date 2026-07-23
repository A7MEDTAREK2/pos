// lib/feature/customer/presentation/widget/empty_customer.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class EmptyCustomer extends StatelessWidget {
  const EmptyCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.people,
            size: 80,
            color: Colorsmanegments.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 10),
          Text(
            "لا يوجد عملاء",
            style: TxtStyle.emptyTitle.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}