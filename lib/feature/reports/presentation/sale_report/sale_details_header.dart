// lib/feature/sales/presentation/widgets/invoice_details/sale_details_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sale_detail_report.dart';

class SaleDetailsHeader extends StatelessWidget {
  final SaleDetailsModel sale;


  const SaleDetailsHeader({
    super.key,
    required this.sale,
  });


  @override

  Widget build(BuildContext context) {
    String orderType;

    switch (sale.orderType) {
      case 0:
        orderType = "تيك أواي";
        break;
      case 1:
        orderType = "داخل المطعم";
        break;
      case 2:
        orderType = "دليفري";
        break;
      default:
        orderType = "-";
    }
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          // ====== Invoice Title ======
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فاتورة رقم #${sale.orderNumber}',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'تم الإنشاء: ${_formatDate(sale.createdAt)}',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          const Spacer(),

          // ====== Order Type Badge ======

          _buildBadge(
            label:orderType,
            color: _getOrderTypeColor(sale.orderType),
            icon: _getOrderTypeIcon(sale.orderType),
          ),

          const SizedBox(width: 12),

          // ====== Payment Badge ======
          _buildBadge(
            label: sale.paymentMethod,
            color: _getPaymentMethodColor(sale.paymentMethod),
            icon: _getPaymentMethodIcon(sale.paymentMethod),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getOrderTypeColor(int type) {
    switch (type) {
      case 0:
        return const Color(0xFFF59E0B);
      case 1:
        return const Color(0xFF16A34A);
      case 2:
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getOrderTypeIcon(int type) {
    switch (type) {
      case 0:
        return Icons.shopping_bag_outlined;
      case 1:
        return Icons.table_restaurant;
      case 2:
        return Icons.delivery_dining;
      default:
        return Icons.help_outline;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return const Color(0xFF16A34A);
      case 'visa':
        return const Color(0xFF2563EB);
      case 'wallet':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'visa':
        return Icons.credit_card;
      case 'wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }

  }



}