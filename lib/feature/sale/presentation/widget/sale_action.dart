// lib/feature/sale/presentation/widget/sale_actions.dart

import 'package:flutter/material.dart';
import 'package:home/feature/sale/presentation/widget/sales_history_dialogs.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class SaleActions extends StatelessWidget {
  final VoidCallback onReopen;
  final VoidCallback onPrint;
  final VoidCallback onDetails;
  final VoidCallback onDelete;


  const SaleActions({
    super.key,
    required this.onReopen,
    required this.onPrint,
    required this.onDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _actionButton(
          tooltip: 'إعادة فتح',
          icon: Iconss.refresh,
          color: Colorsmanegments.warning,
          onTap: onReopen,
        ),
        _actionButton(
          tooltip: 'طباعة',
          icon: Iconss.print,
          color: Colorsmanegments.primary,
          onTap: onPrint,
        ),
        _actionButton(
          tooltip: 'التفاصيل',
          icon: Iconss.view,
          color: Colorsmanegments.success,
          onTap: onDetails,
        ),
        _actionButton(
          tooltip: 'حذف',
          icon: Iconss.delete,
          color: Colorsmanegments.danger,
          onTap: onDelete,
        ),
      ],
    );
  }

  Widget _actionButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,

  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }
}

class SaleActionDialogs {
  const SaleActionDialogs._();

  static Future<bool> confirmDelete(BuildContext context) async {
    return await SalesHistoryDialogs.showConfirmDialog(
      context: context,
      title: "حذف الفاتورة",
      message: "هل أنت متأكد من حذف هذه الفاتورة؟",
      color: Colorsmanegments.danger,
      icon: Iconss.delete,
      confirmText: "حذف",
    ) ??
        false;
  }

  static Future<bool> confirmReopen(BuildContext context) async {
    return await SalesHistoryDialogs.showConfirmDialog(
      context: context,
      title: "إعادة فتح الأوردر",
      message: "سيتم تحويل الفاتورة إلى Holding Order مرة أخرى.",
      color: Colorsmanegments.warning,
      icon: Iconss.refresh,
      confirmText: "إعادة فتح",
    ) ??
        false;
  }
}