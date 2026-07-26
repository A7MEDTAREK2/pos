import 'package:flutter/material.dart';
import '../../../../core/theming/txt_style.dart';

class NotesDialog extends StatelessWidget {
  final TextEditingController controller;

  const NotesDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "ملاحظات المنتج",
        style: TxtStyle.headerSmall,
      ),
      content: Tooltip(
        message: "Ctrl + N - كتابة الملاحظة",
        waitDuration: const Duration(milliseconds: 300),
        child: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "اكتب الملاحظة...",
            hintStyle: TxtStyle.hint,
          ),
        ),
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
          message: "Enter - حفظ",
          waitDuration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: Text(
              "حفظ",
              style: TxtStyle.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }
}