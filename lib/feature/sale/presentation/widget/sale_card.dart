// lib/feature/sale/presentation/widget/sale_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../data/model/sale_model.dart';
import 'sale_details_bottom_sheet.dart';

class SaleCard extends StatelessWidget {
  final SalesHistoryModel sale;
  final VoidCallback onReopen;
  final VoidCallback onPrint;
  final VoidCallback onDetails;
  final VoidCallback onDelete;

  const SaleCard({
    super.key,
    required this.sale,
    required this.onReopen,
    required this.onPrint,
    required this.onDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onDetails,
        splashColor: Colorsmanegments.primary.withOpacity(0.1),
        highlightColor: Colorsmanegments.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildCustomerInfo(),
              if (sale.customerPhone.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildPhone(),
              ],
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    icon: Iconss.refresh,
                    label: 'إعادة فتح',
                    color: Colorsmanegments.warning,
                    onTap: onReopen,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Iconss.print,
                    label: 'طباعة',
                    color: Colorsmanegments.primary,
                    onTap: onPrint,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Iconss.view,
                    label: 'تفاصيل',
                    color: Colorsmanegments.purple,
                    onTap: () {
                      SaleDetailsBottomSheet.show(
                        context,
                        sale.id,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Iconss.delete,
                    label: 'حذف',
                    color: Colorsmanegments.danger,
                    onTap: onDelete,
                    isDelete: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colorsmanegments.primary.withOpacity(0.1),
                Colorsmanegments.primary.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colorsmanegments.primary.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconss.receipt,
                size: 14,
                color: Colorsmanegments.primary,
              ),
              const SizedBox(width: 4),
              Text(
                "#${sale.orderNumber}",
                style: TxtStyle.tableRowBold.copyWith(
                  color: Colorsmanegments.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _orderTypeColor().withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _orderTypeColor().withOpacity(0.2),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getOrderTypeIcon(),
                size: 13,
                color: _orderTypeColor(),
              ),
              const SizedBox(width: 4),
              Text(
                sale.orderTypeStringAr,
                style: TxtStyle.badgeSmall.copyWith(
                  color: _orderTypeColor(),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colorsmanegments.success.withOpacity(0.1),
                Colorsmanegments.success.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colorsmanegments.success.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${sale.total.toStringAsFixed(2)}',
                style: TxtStyle.totalSmall.copyWith(
                  color: Colorsmanegments.success,
                ),
              ),
              Text(
                'ج.م',
                style: TxtStyle.labelSmall.copyWith(
                  color: Colorsmanegments.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colorsmanegments.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colorsmanegments.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Iconss.person,
              size: 16,
              color: Colorsmanegments.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              sale.displayCustomerName,
              style: TxtStyle.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colorsmanegments.border,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconss.calendar,
                  size: 11,
                  color: Colorsmanegments.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(sale.createdAt),
                  style: TxtStyle.labelSmall.copyWith(
                    color: Colorsmanegments.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhone() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colorsmanegments.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Iconss.phone,
              size: 14,
              color: Colorsmanegments.success,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            sale.customerPhone,
            style: TxtStyle.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDelete
              ? Colorsmanegments.danger.withOpacity(0.08)
              : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDelete
                ? Colorsmanegments.danger.withOpacity(0.2)
                : color.withOpacity(0.15),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDelete ? Colorsmanegments.danger : color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TxtStyle.badgeSmall.copyWith(
                color: isDelete ? Colorsmanegments.danger : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _orderTypeColor() {
    switch (sale.orderType) {
      case 0:
        return Colorsmanegments.primary;
      case 1:
        return Colorsmanegments.warning;
      case 2:
        return Colorsmanegments.success;
      default:
        return Colorsmanegments.grey;
    }
  }

  IconData _getOrderTypeIcon() {
    switch (sale.orderType) {
      case 0:
        return Iconss.takeaway;
      case 1:
        return Iconss.dining;
      case 2:
        return Iconss.delivery;
      default:
        return Iconss.help;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}