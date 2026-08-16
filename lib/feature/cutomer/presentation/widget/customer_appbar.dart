// lib/feature/customer/presentation/widget/customer_appbar.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color shadowColor;
  final double elevation;
  final double titleFontSize;
  final double bottomBorderRadius;
  final bool showBottomBorder;
  final String titleText;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomerAppBar({
    super.key,
    this.backgroundColor = Colorsmanegments.primary,
    this.foregroundColor = Colorsmanegments.textWhite,
    this.shadowColor = Colorsmanegments.primaryDark,
    this.elevation = 4.0,
    this.titleFontSize = 22.0,
    this.bottomBorderRadius = 16.0,
    this.showBottomBorder = true,
    this.titleText = "العملاء",
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // استخدام الألوان من Theme إذا كانت القيم الافتراضية
    final bgColor = backgroundColor == Colorsmanegments.primary
        ? colorScheme.primary
        : backgroundColor;
    final fgColor = foregroundColor == Colorsmanegments.textWhite
        ? colorScheme.onPrimary
        : foregroundColor;
    final shadowCol = shadowColor == Colorsmanegments.primaryDark
        ? colorScheme.primary
        : shadowColor;

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      shadowColor: shadowCol.withOpacity(0.3),

      shape: showBottomBorder
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(bottomBorderRadius),
        ),
      )
          : null,

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconss.people,
            color: fgColor,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            titleText,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
          ),
        ],
      ),
      centerTitle: true,

      leading: showBackButton
          ? IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: Icon(
          Iconss.arrowBack,
          color: fgColor,
        ),
        tooltip: 'رجوع',
      )
          : null,

      toolbarTextStyle: TextStyle(
        color: fgColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleTextStyle: TextStyle(
        color: fgColor,
        fontSize: titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}