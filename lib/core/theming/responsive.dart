import 'package:flutter/material.dart';

class ResponsiveManager {
  static const double desktopWidth = 1200;
  static const double tabletWidth = 800;
  static const double mobileWidth = 600;

  // إرجاع نوع الشاشة
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return ScreenType.desktop;
    if (width >= tabletWidth) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  // هل هي شاشة كبيرة
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletWidth &&
          MediaQuery.of(context).size.width < desktopWidth;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletWidth;

  // عرض مخصص حسب نوع الشاشة
  static double getCartPanelWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return width * 0.32; // 32% للشاشات الكبيرة
    if (width >= tabletWidth) return width * 0.40; // 40% للتابلت
    return width; // عرض كامل للموبايل
  }

  static double getProductGridFlex(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 4;
    if (width >= tabletWidth) return 3;
    if (width >= mobileWidth) return 2;
    return 1;
  }

  static double getFontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return size * 1.1;
    if (width >= tabletWidth) return size * 1.0;
    if (width >= mobileWidth) return size * 0.95;
    return size * 0.9;
  }

  static double getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 24.0;
    if (width >= tabletWidth) return 16.0;
    return 12.0;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    if (width >= tabletWidth) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
    return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  }
}

enum ScreenType { mobile, tablet, desktop }