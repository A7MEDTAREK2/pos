import 'package:flutter/material.dart';
import '../../data/model/customer_model.dart';

class CustomerItem extends StatelessWidget {
  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryColor = Colors.blue.shade700;
  final Color secondaryColor = Colors.grey.shade700;
  final Color cardColor = Colors.white;
  final Color borderColor = Colors.blue.shade50;
  final double cardElevation = 3.0;
  final double cardBorderRadius = 14.0;
  final double avatarSize = 48.0;
  final double avatarTextSize = 20.0;
  final Color avatarColor = Colors.blue.shade100;
  final Color avatarTextColor = Colors.blue.shade700;
  final double nameFontSize = 17.0;
  final double subtitleFontSize = 14.0;
  final double iconSize = 18.0;
  final double horizontalPadding = 16.0;
  final double verticalPadding = 14.0;
  final Color editIconColor = Colors.blue.shade600;
  final Color deleteIconColor = Colors.red.shade600;

  final CustomerModel customer;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

   CustomerItem({
    super.key,
    required this.customer,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  // ====== دالة لاستخراج أول حرف من الاسم ======
  String _getInitial() {
    if (customer.name.isEmpty) return '?';
    return customer.name.trim()[0].toUpperCase();
  }

  // ====== دالة لتنسيق التاريخ ======
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
      elevation: cardElevation,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            // ====== الـ Avatar ======
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    avatarColor,
                    primaryColor.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.transparent,
                child: Text(
                  _getInitial(),
                  style: TextStyle(
                    fontSize: avatarTextSize,
                    fontWeight: FontWeight.bold,
                    color: avatarTextColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ====== المعلومات ======
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== الاسم ======
                  Text(
                    customer.name,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // ====== رقم الهاتف ======
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: iconSize,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        customer.phone,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),

                  // ====== تاريخ الإضافة (إذا موجود) ======
                  if (customer.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: iconSize - 2,
                          color: secondaryColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(customer.createdAt),
                          style: TextStyle(
                            fontSize: subtitleFontSize - 1,
                            color: secondaryColor.withOpacity(0.6),
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
              // زر التعديل
              if (onEdit != null)
                Container(
                  decoration: BoxDecoration(
                    color: editIconColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      color: editIconColor,
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ),

              if (onEdit != null && onDelete != null)
                const SizedBox(width: 4),

              // زر الحذف
              if (onDelete != null)
                Container(
                  decoration: BoxDecoration(
                    color: deleteIconColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: deleteIconColor,
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