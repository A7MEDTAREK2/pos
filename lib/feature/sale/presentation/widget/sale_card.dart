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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onDetails,
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, sale),
              const SizedBox(height: 12),
              _buildCustomerInfo(context, sale),
              if (sale.customerPhone.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildPhone(context, sale),
              ],
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    context,
                    icon: Iconss.refresh,
                    label: 'إعادة فتح',
                    color: Colors.amber,
                    onTap: onReopen,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    context,
                    icon: Iconss.print,
                    label: 'طباعة',
                    color: colorScheme.primary,
                    onTap: onPrint,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    context,
                    icon: Iconss.view,
                    label: 'تفاصيل',
                    color: Colors.purple,
                    onTap: () {
                      SaleDetailsBottomSheet.show(
                        context,
                        sale.id,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    context,
                    icon: Iconss.delete,
                    label: 'حذف',
                    color: Colors.red,
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

  Widget _buildHeader(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.1),
                colorScheme.primary.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconss.receipt,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                "#${sale.orderNumber}",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _orderTypeColor(sale.orderType).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _orderTypeColor(sale.orderType).withOpacity(0.2),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getOrderTypeIcon(sale.orderType),
                size: 13,
                color: _orderTypeColor(sale.orderType),
              ),
              const SizedBox(width: 4),
              Text(
                sale.orderTypeStringAr,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _orderTypeColor(sale.orderType),
                  fontWeight: FontWeight.bold,
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
                Colors.green.withOpacity(0.1),
                Colors.green.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${sale.total.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ج.م',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Iconss.person,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              sale.displayCustomerName,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconss.calendar,
                  size: 11,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(sale.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhone(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Iconss.phone,
              size: 14,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            sale.customerPhone,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
        bool isDelete = false,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDelete
              ? Colors.red.withOpacity(0.08)
              : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDelete
                ? Colors.red.withOpacity(0.2)
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
              color: isDelete ? Colors.red : color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDelete ? Colors.red : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _orderTypeColor(int type) {
    switch (type) {
      case 0:
        return const Color(0xFF2563EB);
      case 1:
        return Colors.amber;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderTypeIcon(int type) {
    switch (type) {
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