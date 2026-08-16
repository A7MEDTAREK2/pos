// lib/feature/settings/presentation/widgets/settings_radio_group.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsRadioGroup extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?>? onChanged;

  const SettingsRadioGroup({
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
        Row(
          children: items.map((item) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(
                  item,
                  style: theme.textTheme.bodyMedium,
                ),
                value: item,
                groupValue: value,
                onChanged: (_) {},
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}