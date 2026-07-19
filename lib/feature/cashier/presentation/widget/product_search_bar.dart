// lib/feature/cashier/presentation/widget/product_search_bar.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TxtStyle.bodyMedium,
        decoration: InputDecoration(
          hintText: "ابحث بالاسم أو الباركود...",
          hintStyle: TxtStyle.hint,
          prefixIcon: Icon(
            Iconss.search,
            color: Colorsmanegments.primary,
          ),
          suffixIcon: Icon(
            Iconss.qrCode,
            color: Colorsmanegments.textSecondary,
          ),
          filled: true,
          fillColor: Colorsmanegments.card,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colorsmanegments.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colorsmanegments.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}