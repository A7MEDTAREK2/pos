// lib/feature/customer/presentation/widget/customer_search.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class CustomerSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomerSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TxtStyle.bodyMedium,
      decoration: InputDecoration(
        hintText: "بحث بالاسم أو الهاتف",
        hintStyle: TxtStyle.hint,
        prefixIcon: Icon(
          Iconss.search,
          color: Colorsmanegments.primary,
        ),
        filled: true,
        fillColor: Colorsmanegments.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colorsmanegments.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colorsmanegments.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colorsmanegments.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}