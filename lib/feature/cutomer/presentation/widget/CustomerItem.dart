// lib/feature/customer/presentation/widget/customer_item.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Customer ======
import '../../data/model/customer_model.dart';

class CustomerItem extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomerItem({
    super.key,
    required this.customer,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _getInitial() {
    if (customer.name.isEmpty) return '?';
    return customer.name.trim()[0].toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: Colorsmanegments.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Colorsmanegments.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ====== Avatar ======
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colorsmanegments.primary.withOpacity(0.2),
                    Colorsmanegments.primary.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colorsmanegments.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: Text(
                  _getInitial(),
                  style: TxtStyle.headerWhite.copyWith(
                    fontSize: 20,
                    color: Colorsmanegments.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ====== معلومات العميل ======
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: TxtStyle.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Iconss.phone,
                        size: 16,
                        color: Colorsmanegments.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        customer.phone,
                        style: TxtStyle.bodySmall,
                      ),
                    ],
                  ),
                  if (customer.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconss.calendar,
                          size: 14,
                          color: Colorsmanegments.textSecondary.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(customer.createdAt),
                          style: TxtStyle.labelSmall.copyWith(
                            color: Colorsmanegments.textSecondary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // ====== أزرار التحكم ======
            if (onEdit != null || onDelete != null) ...[
              if (onEdit != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colorsmanegments.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Iconss.edit,
                      color: Colorsmanegments.primary,
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ),
              if (onEdit != null && onDelete != null)
                const SizedBox(width: 4),
              if (onDelete != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colorsmanegments.danger.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Iconss.delete,
                      color: Colorsmanegments.danger,
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}