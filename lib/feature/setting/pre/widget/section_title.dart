// lib/feature/settings/presentation/widgets/section_title.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/txt_style.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}