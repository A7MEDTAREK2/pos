// lib/feature/reports/presentation/widgets/reports_content.dart

import 'package:flutter/material.dart';

import '../Customer Report/screen/customer_report_screen.dart';
import '../Order Type Report/screen/orderType_report_screen.dart';
import '../Payment Report/screen/payment_report_screen.dart';
import '../Stock Report/screen/stock_report_screen.dart';
import '../drive_report/screen/DriverReportScreen.dart';
import '../product_report/screen/product_report_screen.dart';
import '../sale_report/sales_report_view.dart';
import 'reports_empty_state.dart';

class ReportsContent extends StatelessWidget {
  final int selectedIndex;

  const ReportsContent({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return const SalesReportView();
      case 1:
        return const ProductReportScreen();
      case 2:
        return const CustomerReportScreen();
      case 3:
        return const StockReportScreen();
      case 4:
        return const PaymentReportScreen();
      case 5:
        return const OrderTypeReportScreen();
      case 6: // <--- أضفنا الـ Case الخاصة بتقرير المناديب هنا
        return const DriverReportScreen(); // (أو DriverReportView حسب اسم الـ Widget بتاعتك)
      default:
        return const ReportsEmptyState();
    }
  }
}