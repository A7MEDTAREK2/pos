// lib/feature/settings/presentation/widgets/settings_dropdown.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?>? onChanged;

  const SettingsDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    this.onChanged,
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
        Container(
          decoration: BoxDecoration(
            color: Colorsmanegments.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colorsmanegments.border,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: TxtStyle.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colorsmanegments.primary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item == "EGP"
                      ? "جنيه مصري"
                      : item == "ar"
                      ? "العربية"
                      : item == "en"
                      ? "English"
                      : item,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: Icon(
              Iconss.arrowForward,
              color: Colorsmanegments.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}