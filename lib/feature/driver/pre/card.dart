import 'package:flutter/material.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../core/theming/colors manegments.dart';
import '../data/model_drive.dart';

class DriverCard extends StatelessWidget {
  final DriverModel driver;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DriverCard({
    super.key,
    required this.driver,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // ====== Avatar ======
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colorsmanegments.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                driver.name.isNotEmpty ? driver.name[0] : '?',
                style: TxtStyle.titleMedium.copyWith(
                  color: Colorsmanegments.primary,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ====== Info ======
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  driver.name,
                  style: TxtStyle.titleSmall.copyWith(
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (driver.phone != null && driver.phone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        size: 14,
                        color: Colorsmanegments.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        driver.phone!,
                        style: TxtStyle.bodySmall.copyWith(
                          color: Colorsmanegments.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // ====== Actions ======
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_rounded,
                  color: Colorsmanegments.primary,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                tooltip: 'تعديل',
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colorsmanegments.danger,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                tooltip: 'حذف',
              ),
            ],
          ),
        ],
      ),
    );
  }
}