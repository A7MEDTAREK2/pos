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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "حذف المنتج",
        style: TxtStyle.headerSmall,
      ),
      content: Text(
        "هل تريد حذف $itemName من الأوردر؟",
        style: TxtStyle.bodyMedium,
      ),
      actions: [
        Tooltip(
          message: "Esc - إلغاء",
          waitDuration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "إلغاء",
              style: TxtStyle.buttonPrimary,
            ),
          ),
        ),
        Tooltip(
          message: "Enter - حذف",
          waitDuration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.danger,
            ),
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Text(
              "حذف",
              style: TxtStyle.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }
}