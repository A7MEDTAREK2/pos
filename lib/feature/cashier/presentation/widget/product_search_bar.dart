// lib/feature/cashier/presentation/widget/product_search_bar.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 52,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Tooltip(
        message: "F2 - البحث عن المنتجات",
        waitDuration: const Duration(milliseconds: 300),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: "ابحث بالاسم أو الباركود...",
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Iconss.search,
              color: colorScheme.primary,
            ),
            suffixIcon: Icon(
              Iconss.qrCode,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}