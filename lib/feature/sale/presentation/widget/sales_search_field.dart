// lib/feature/sale/presentation/widget/sales_search_field.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class SalesSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SalesSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TxtStyle.bodyMedium,
        decoration: InputDecoration(
          hintText: "بحث برقم الفاتورة، اسم العميل أو طريقة الدفع...",
          hintStyle: TxtStyle.hint,
          prefixIcon: Icon(
            Iconss.search,
            color: Colorsmanegments.primary,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox();

              return IconButton(
                icon: Icon(
                  Iconss.clear,
                  color: Colorsmanegments.textSecondary,
                ),
                onPressed: onClear,
              );
            },
          ),
          filled: true,
          fillColor: Colorsmanegments.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colorsmanegments.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}