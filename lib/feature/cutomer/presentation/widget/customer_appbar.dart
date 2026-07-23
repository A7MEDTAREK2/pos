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
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shadowColor: shadowColor.withOpacity(0.3),

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
            color: foregroundColor,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            titleText,
            style: TxtStyle.headerWhite.copyWith(
              fontSize: titleFontSize,
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
          color: foregroundColor,
        ),
        tooltip: 'رجوع',
      )
          : null,

      toolbarTextStyle: TextStyle(
        color: foregroundColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleTextStyle: TextStyle(
        color: foregroundColor,
        fontSize: titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}