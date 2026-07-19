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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ====== Summary ======
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummaryRow('الإجمالي الفرعي', sale.subtotal),
              if (sale.discount > 0)
                _buildSummaryRow('الخصم', -sale.discount, isDiscount: true),
              if (sale.tax > 0) _buildSummaryRow('الضريبة', sale.tax),
              if (sale.deliveryFee > 0)
                _buildSummaryRow('رسوم التوصيل', sale.deliveryFee),

              const SizedBox(height: 12),

              Container(
                height: 1,
                width: 200,
                color: const Color(0xFFE5E7EB),
              ),

              const SizedBox(height: 12),

              // ====== Grand Total ======
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'الإجمالي',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${sale.total.toStringAsFixed(2)} ج.م',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildSummaryRow(String label, double value,
      {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '${isDiscount ? '-' : ''}${value.toStringAsFixed(2)} ج.م',
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDiscount ? const Color(0xFFDC2626) : const Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}