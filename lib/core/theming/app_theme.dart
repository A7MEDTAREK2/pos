// lib/core/theming/app_theme.dart

import 'package:flutter/material.dart';
import 'colors manegments.dart';
import 'txt_style.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // Light Theme Configuration
  // ============================================================
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: Colorsmanegments.primary,
      onPrimary: Colorsmanegments.textWhite,
      secondary: Colorsmanegments.primaryLight,
      onSecondary: Colorsmanegments.textWhite,
      surface: Colorsmanegments.backgroundLight,
      onSurface: Colorsmanegments.textPrimary,
      background: Colorsmanegments.background,
      onBackground: Colorsmanegments.textPrimary,
      error: Colorsmanegments.danger,
      onError: Colorsmanegments.textWhite,
      shadow: Colorsmanegments.blackOpacity10,
      outline: Colorsmanegments.border,
      outlineVariant: Colorsmanegments.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colorsmanegments.background,

      textTheme: TextTheme(
        displayLarge: TxtStyle.headerLarge.copyWith(color: colorScheme.onSurface),
        displayMedium: TxtStyle.headerMedium.copyWith(color: colorScheme.onSurface),
        displaySmall: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        headlineLarge: TxtStyle.headerLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: TxtStyle.headerMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        titleLarge: TxtStyle.titleLarge.copyWith(color: colorScheme.onSurface),
        titleMedium: TxtStyle.titleMedium.copyWith(color: colorScheme.onSurface),
        titleSmall: TxtStyle.titleSmall.copyWith(color: colorScheme.onSurface),
        bodyLarge: TxtStyle.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: TxtStyle.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: TxtStyle.bodySmall.copyWith(color: Colorsmanegments.textSecondary),
        labelLarge: TxtStyle.labelLarge.copyWith(color: colorScheme.onSurface),
        labelMedium: TxtStyle.labelMedium.copyWith(color: Colorsmanegments.textSecondary),
        labelSmall: TxtStyle.labelSmall.copyWith(color: Colorsmanegments.textSecondary),
      ),

      cardTheme: CardThemeData(
        color: Colorsmanegments.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colorsmanegments.card,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colorsmanegments.backgroundLight,
        hintStyle: TxtStyle.hint.copyWith(color: Colorsmanegments.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colorsmanegments.borderError),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TxtStyle.buttonMedium.copyWith(color: colorScheme.onPrimary),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colorsmanegments.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: Colorsmanegments.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: Colorsmanegments.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
        titleTextStyle: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        contentTextStyle: TxtStyle.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
    );
  }

  // ============================================================
  // Dark Theme Configuration
  // ============================================================
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: Colorsmanegments.primaryHover,
      onPrimary: Colorsmanegments.textWhite,
      secondary: Colorsmanegments.primaryDark,
      onSecondary: Colorsmanegments.textWhite,
      surface: Colorsmanegments.grey800,
      onSurface: Colorsmanegments.textWhite,
      background: Colorsmanegments.grey900,
      onBackground: Colorsmanegments.textWhite,
      error: Colorsmanegments.danger,
      onError: Colorsmanegments.textWhite,
      shadow: Colorsmanegments.blackOpacity10, // ✅ تم تغييرها إلى blackOpacity10
      outline: Colorsmanegments.grey700,
      outlineVariant: Colorsmanegments.grey600,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colorsmanegments.grey900,

      textTheme: TextTheme(
        displayLarge: TxtStyle.headerLarge.copyWith(color: colorScheme.onSurface),
        displayMedium: TxtStyle.headerMedium.copyWith(color: colorScheme.onSurface),
        displaySmall: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        headlineLarge: TxtStyle.headerLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: TxtStyle.headerMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        titleLarge: TxtStyle.titleLarge.copyWith(color: colorScheme.onSurface),
        titleMedium: TxtStyle.titleMedium.copyWith(color: colorScheme.onSurface),
        titleSmall: TxtStyle.titleSmall.copyWith(color: colorScheme.onSurface),
        bodyLarge: TxtStyle.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: TxtStyle.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: TxtStyle.bodySmall.copyWith(color: Colorsmanegments.grey400),
        labelLarge: TxtStyle.labelLarge.copyWith(color: colorScheme.onSurface),
        labelMedium: TxtStyle.labelMedium.copyWith(color: Colorsmanegments.grey400),
        labelSmall: TxtStyle.labelSmall.copyWith(color: Colorsmanegments.grey400),
      ),

      cardTheme: CardThemeData(
        color: Colorsmanegments.grey800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colorsmanegments.grey800,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colorsmanegments.grey800,
        hintStyle: TxtStyle.hint.copyWith(color: Colorsmanegments.grey400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colorsmanegments.danger),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TxtStyle.buttonMedium.copyWith(color: colorScheme.onPrimary),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colorsmanegments.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: Colorsmanegments.grey800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      dialogTheme: DialogThemeData( // ✅ تم التغيير من DialogTheme إلى DialogThemeData
        backgroundColor: Colorsmanegments.grey800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
        titleTextStyle: TxtStyle.headerSmall.copyWith(color: colorScheme.onSurface),
        contentTextStyle: TxtStyle.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}