// lib/feature/settings/presentation/widgets/settings_section.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colorsmanegments.primary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TxtStyle.headerSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}