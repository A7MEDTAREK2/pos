// lib/feature/settings/presentation/widgets/settings_action_button.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/txt_style.dart';

class SettingsActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isFullWidth;

  const SettingsActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? SizedBox(
      width: double.infinity,
      child: _buildButton(),
    )
        : _buildButton();
  }

  Widget _buildButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.08),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        side: BorderSide(
          color: color.withOpacity(0.2),
        ),
      ),
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
        color: color,
      ),
      label: Text(
        label,
        style: TxtStyle.buttonMedium.copyWith(
          color: color,
        ),
      ),
    );
  }
}