// lib/core/theming/txt_style.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors manegments.dart';

class TxtStyle {
  // ============================================================
  // Headers
  // ============================================================
  static TextStyle headerLarge = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle headerMedium = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle headerSmall = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle headerWhite = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textWhite,
  );

  // ============================================================
  // Titles
  // ============================================================
  static TextStyle titleLarge = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.primary,
  );

  static TextStyle titleMedium = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.primary,
  );

  static TextStyle titleSmall = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle titleCard = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  // ============================================================
  // Body Text
  // ============================================================
  static TextStyle bodyLarge = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textSecondary,
  );

  static TextStyle bodyWhite = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textWhite,
  );

  // ============================================================
  // Labels
  // ============================================================
  static TextStyle labelLarge = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textSecondary,
  );

  static TextStyle labelMedium = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colorsmanegments.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colorsmanegments.textLight,
  );

  static TextStyle labelBold = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  // ============================================================
  // Buttons
  // ============================================================
  static TextStyle buttonLarge = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textWhite,
  );

  static TextStyle buttonMedium = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textWhite,
  );

  static TextStyle buttonSmall = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textWhite,
  );

  static TextStyle buttonPrimary = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.primary,
  );

  static TextStyle buttonDanger = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.danger,
  );

  // ============================================================
  // Table Headers
  // ============================================================
  static TextStyle tableHeader = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textSecondary,
  );

  static TextStyle tableRow = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle tableRowBold = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle tableRowRevenue = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.success,
  );

  static TextStyle tableRowIndex = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colorsmanegments.textLight,
  );

  static TextStyle tableRowTotal = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.primary,
  );

  // ============================================================
  // Total / Summary
  // ============================================================
  static TextStyle totalLarge = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.primary,
  );

  static TextStyle totalMedium = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.success,
  );

  static TextStyle totalSmall = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle totalRevenue = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.success,
  );

  // ============================================================
  // Empty State
  // ============================================================
  static TextStyle emptyTitle = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle emptySubtitle = GoogleFonts.cairo(
    fontSize: 14,
    color: Colorsmanegments.textSecondary,
  );

  // ============================================================
  // Badge
  // ============================================================
  static TextStyle badge = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textWhite,
  );

  static TextStyle badgeSmall = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static TextStyle badgeSuccess = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.success,
  );

  static TextStyle badgeWarning = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.warning,
  );

  static TextStyle badgeDanger = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.danger,
  );

  // ============================================================
  // Hint / Placeholder
  // ============================================================
  static TextStyle hint = GoogleFonts.cairo(
    fontSize: 13,
    color: Colorsmanegments.textLight,
  );

  static TextStyle hintSmall = GoogleFonts.cairo(
    fontSize: 12,
    color: Colorsmanegments.textLight,
  );

  static TextStyle hintMedium = GoogleFonts.cairo(
    fontSize: 14,
    color: Colorsmanegments.textLight,
  );

  // ============================================================
  // Status / State
  // ============================================================
  static TextStyle success = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.success,
  );

  static TextStyle danger = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.danger,
  );

  static TextStyle warning = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.warning,
  );

  static TextStyle info = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.info,
  );

  // ============================================================
  // Dashboard
  // ============================================================
  static TextStyle dashboardValue = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle dashboardTitle = GoogleFonts.cairo(
    fontSize: 13,
    color: Colorsmanegments.textSecondary,
  );

  static TextStyle dashboardChange = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // ============================================================
  // Reports
  // ============================================================
  static TextStyle reportTitle = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle reportSubtitle = GoogleFonts.cairo(
    fontSize: 14,
    color: Colorsmanegments.textSecondary,
  );

  // ============================================================
  // Sidebar
  // ============================================================
  static TextStyle sidebarItem = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colorsmanegments.textPrimary,
  );

  static TextStyle sidebarItemSelected = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colorsmanegments.textWhite,
  );

  static TextStyle sidebarTitle = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colorsmanegments.textPrimary,
  );
}