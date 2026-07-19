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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.title,
        style: TxtStyle.headerSmall,
      ),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TxtStyle.bodyMedium,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colorsmanegments.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorsmanegments.primary,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Iconss.edit,
            color: Colorsmanegments.primary,
            size: 20,
          ),
          filled: true,
          fillColor: Colorsmanegments.background,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "إلغاء",
            style: TxtStyle.buttonPrimary,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colorsmanegments.primary,
            foregroundColor: Colorsmanegments.textWhite,
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
            style: TxtStyle.buttonMedium,
          ),
        ),
      ],
    );
  }
}