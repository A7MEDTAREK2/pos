// lib/feature/sale/presentation/widget/sales_history_dialogs.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class SalesHistoryDialogs {
  SalesHistoryDialogs._();


  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Color color,
    required IconData icon,
    String confirmText = "تأكيد",
    String cancelText = "إلغاء",
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TxtStyle.headerSmall,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TxtStyle.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: TxtStyle.buttonPrimary,
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                confirmText,
                style: TxtStyle.buttonMedium.copyWith(
                  color: Colorsmanegments.textWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TxtStyle.bodyMedium.copyWith(
              color: Colorsmanegments.textWhite,
            ),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}