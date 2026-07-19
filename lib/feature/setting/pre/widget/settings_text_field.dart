// lib/feature/settings/presentation/widgets/settings_text_field.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String? initialValue;
  final bool readOnly;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.initialValue,
    this.readOnly = false, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TxtStyle.labelMedium,
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          style: TxtStyle.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TxtStyle.hint,
            prefixIcon: Icon(
              icon,
              color: Colorsmanegments.primary,
              size: 20,
            ),
            filled: true,
            fillColor: Colorsmanegments.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colorsmanegments.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colorsmanegments.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colorsmanegments.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}