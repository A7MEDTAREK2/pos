// lib/feature/sales/presentation/widgets/invoice_details/sale_customer_info.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sale_detail_report.dart';

class SaleCustomerInfo extends StatelessWidget {
  final SaleDetailsModel sale;

  const SaleCustomerInfo({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // ====== Customer Avatar ======
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person,
              size: 24,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 16),

          // ====== Customer Info ======
          Expanded(
            child: Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildInfoItem(
                  context,
                  label: 'العميل',
                  value: sale.customerName ?? 'عميل نقدي',
                ),
                _buildInfoItem(
                  context,
                  label: 'الهاتف',
                  value: sale.customerPhone ?? '--',
                ),
                _buildInfoItem(
                  context,
                  label: 'العنوان',
                  value: sale.customerAddress ?? '--',
                ),
                _buildInfoItem(
                  context,
                  label: 'رقم الطلب',
                  value: '#${sale.orderNumber}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, {
        required String label,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}