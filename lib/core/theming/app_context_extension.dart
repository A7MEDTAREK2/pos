// lib/core/theming/app_context_extension.dart

import 'package:flutter/material.dart';
import 'colors manegments.dart';

extension AppContextExtension on BuildContext {
  // للوصول للـ Theme الحالي بسرعة
  ThemeData get theme => Theme.of(this);

  // للوصول لألوان الكلاس Colorsmanegments مباشرة من السياق لو حبيت
  Colorsmanegments get colors => Colorsmanegments();

  // التحقق هل التطبيق في الوضع الليلي ولا الفاتح
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // مقاسات الشاشة لسهولة الـ Responsive
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}