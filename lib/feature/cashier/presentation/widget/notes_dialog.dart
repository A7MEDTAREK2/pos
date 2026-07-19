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
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "اكتب الملاحظة...",
          hintStyle: TxtStyle.hint,
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
          onPressed: () {
            Navigator.pop(context, controller.text);
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