// lib/feature/sales/presentation/widgets/invoice_details/sale_summary_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sale_detail_report.dart';

class SaleSummaryCard extends StatelessWidget {
  final SaleDetailsModel sale;

  const SaleSummaryCard({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ====== Summary ======
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummaryRow(
                context,
                'الإجمالي الفرعي',
                sale.subtotal,
              ),
              if (sale.discount > 0)
                _buildSummaryRow(
                  context,
                  'الخصم',
                  -sale.discount,
                  isDiscount: true,
                ),
              if (sale.tax > 0)
                _buildSummaryRow(
                  context,
                  'الضريبة',
                  sale.tax,
                ),
              if (sale.deliveryFee > 0)
                _buildSummaryRow(
                  context,
                  'رسوم التوصيل',
                  sale.deliveryFee,
                ),

              const SizedBox(height: 12),

              Container(
                height: 1,
                width: 200,
                color: theme.dividerColor,
              ),

              const SizedBox(height: 12),

              // ====== Grand Total ======
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'الإجمالي',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${sale.total.toStringAsFixed(2)} ج.م',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      double value, {
        bool isDiscount = false,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '${isDiscount ? '-' : ''}${value.toStringAsFixed(2)} ج.م',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDiscount ? Colors.red : colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}