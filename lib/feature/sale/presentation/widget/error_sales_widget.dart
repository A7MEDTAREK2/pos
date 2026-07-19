// lib/feature/sale/presentation/widget/error_sales_widget.dart

import 'package:flutter/material.dart';

import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Core ======


class ErrorSalesWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorSalesWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.error,
            size: 70,
            color: Colorsmanegments.danger.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TxtStyle.danger.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.primary,
              foregroundColor: Colorsmanegments.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onRetry,
            icon: Icon(
              Iconss.refresh,
              color: Colorsmanegments.textWhite,
              size: 18,
            ),
            label: Text(
              "إعادة المحاولة",
              style: TxtStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}