 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemes {
  static TextTheme textTheme = TextTheme(
    // Display styles
    displayLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 28),
    displayMedium: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 26),
    displaySmall: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24),

    // Headline styles
    headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22),
    headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17),

    // Title styles
    titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18),
    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
    titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),

    // Body styles
    bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 18),
    bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16),
    bodySmall: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14),

    // Label styles
    labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15),
    labelMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
    labelSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11),
  );

  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    useMaterial3: true,
    textTheme: textTheme,
  );
}