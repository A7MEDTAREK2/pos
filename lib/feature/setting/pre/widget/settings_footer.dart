// lib/feature/settings/presentation/widgets/settings_footer.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class SettingsFooter extends StatelessWidget {
  final VoidCallback onPressed; // 👈 1. إعلان المتغير بشكل صحيح

  const SettingsFooter({
    super.key,
    required this.onPressed, // 👈 2. ربطه بالـ Constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colorsmanegments.primary,
          foregroundColor: Colorsmanegments.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: onPressed, // 👈 3. ربط الضغطة بالدالة القادمة من SettingsScreen
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconss.save,
              color: Colorsmanegments.textWhite,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'حفظ الإعدادات',
              style: TxtStyle.buttonLarge,
            ),
          ],
        ),
      ),
    );
  }
}