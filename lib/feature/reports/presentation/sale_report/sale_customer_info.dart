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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // ====== Customer Avatar ======
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person,
              size: 24,
              color: Color(0xFF2563EB),
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
                  label: 'العميل',
                  value: sale.customerName ?? 'عميل نقدي',
                ),
                _buildInfoItem(
                  label: 'الهاتف',
                  value: sale.customerPhone ?? '--',
                ),
                _buildInfoItem(
                  label: 'العنوان',
                  value: sale.customerAddress ?? '--',
                ),
                _buildInfoItem(
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

  Widget _buildInfoItem({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}