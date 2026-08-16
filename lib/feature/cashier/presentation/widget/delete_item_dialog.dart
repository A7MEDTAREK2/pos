import 'package:flutter/material.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class DeleteItemDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onDelete;

  const DeleteItemDialog({
    super.key,
    required this.itemName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "حذف المنتج",
        style: theme.textTheme.titleLarge,
      ),
      content: Text(
        "هل تريد حذف $itemName من الأوردر؟",
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        Tooltip(
          message: "Esc - إلغاء",
          waitDuration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "إلغاء",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        Tooltip(
          message: "Enter - حذف",
          waitDuration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Text(
              "حذف",
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}