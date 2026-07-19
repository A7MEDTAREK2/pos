// lib/feature/settings/presentation/widgets/settings_switch.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TxtStyle.bodyMedium,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colorsmanegments.primary,
          activeTrackColor: Colorsmanegments.primary.withOpacity(0.3),
        ),
      ],
    );
  }
}