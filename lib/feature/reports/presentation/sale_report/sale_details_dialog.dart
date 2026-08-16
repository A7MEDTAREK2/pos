// lib/feature/sales/presentation/widgets/invoice_details/sale_details_dialog.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_actions_bar.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_customer_info.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_details_header.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_items_table.dart';
import 'package:home/feature/reports/presentation/sale_report/sale_summary_card.dart';

import '../../data/model/sale_detail_report.dart';

class SaleDetailsDialog extends StatelessWidget {
  final SaleDetailsModel sale;

  const SaleDetailsDialog({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 950,
        constraints: const BoxConstraints(
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // ====== Header ======
            SaleDetailsHeader(sale: sale),

            // ====== Body ======
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ====== Customer Info ======
                    SaleCustomerInfo(sale: sale),

                    const SizedBox(height: 24),

                    // ====== Items Table ======
                    SaleItemsTable(items: sale.items),

                    const SizedBox(height: 24),

                    // ====== Summary ======
                    SaleSummaryCard(sale: sale),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ====== Actions Bar ======
            SaleActionsBar(sale: sale),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
      BuildContext context,
      SaleDetailsModel sale,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: colorScheme.shadow.withOpacity(0.4),
      builder: (_) => FadeTransition(
        opacity: const AlwaysStoppedAnimation(1),
        child: SaleDetailsDialog(sale: sale),
      ),
    );
  }
}