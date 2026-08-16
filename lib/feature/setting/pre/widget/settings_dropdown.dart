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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: colorScheme.primary,
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
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}