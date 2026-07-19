import 'package:flutter/material.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ====== متغيرات التحكم في الـ UI ======
  final Color backgroundColor = Colors.blue.shade700;
  final Color foregroundColor = Colors.white;
  final Color shadowColor = Colors.blue.shade900;
  final double elevation = 4.0;
  final double titleFontSize = 22.0;
  final double bottomBorderRadius = 16.0;
  final bool showBottomBorder = true;
  final String titleText = "العملاء";
  final String searchHint = "بحث عن عميل...";
  final bool showSearchButton = true;
  final bool showAddButton = true;
  final bool showBackButton = false;

  final VoidCallback? onSearchPressed;
  final VoidCallback? onAddPressed;
  final VoidCallback? onBackPressed;

   CustomerAppBar({
    super.key,
    this.onSearchPressed,
    this.onAddPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shadowColor: shadowColor.withOpacity(0.3),

      // ====== شكل الـ AppBar ======
      shape: showBottomBorder
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(bottomBorderRadius),
        ),
      )
          : null,

      // ====== عنوان الصفحة ======
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt,
            color: foregroundColor,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            titleText,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: foregroundColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      centerTitle: true,

      // ====== زر الرجوع (اختياري) ======
      leading: showBackButton
          ? IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
        tooltip: 'رجوع',
      )
          : null,



      // ====== تنسيق النصوص ======
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