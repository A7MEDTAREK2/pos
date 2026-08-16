// lib/feature/cashier/presentation/widget/edit_amount_dialog.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class EditAmountDialog extends StatefulWidget {
  final String title;
  final double value;

  const EditAmountDialog({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<EditAmountDialog> createState() => _EditAmountDialogState();
}

class _EditAmountDialogState extends State<EditAmountDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    controller =
        TextEditingController(text: widget.value.toStringAsFixed(2));
    super.initState();
  }

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
        widget.title,
        style: theme.textTheme.titleLarge,
      ),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Iconss.edit,
            color: colorScheme.primary,
            size: 20,
          ),
          filled: true,
          fillColor: colorScheme.background,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "إلغاء",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(
              context,
              double.tryParse(controller.text) ?? widget.value,
            );
          },
          child: Text(
            "حفظ",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}