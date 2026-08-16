import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),

      headlineLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),

      titleLarge: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),

      bodyLarge: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.normal),

      labelLarge: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w500),
    );
  }
}