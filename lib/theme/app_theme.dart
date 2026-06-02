import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color darkBg = Color(0xFF0C0C0E);
  static const Color cardBg = Color(0xFF16161A);
  static const Color accentBlue = Color(0xFF00D2FF);
  static const Color accentPink = Color(0xFFFF0844);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentPurple = Color(0xFF8A2BE2);
  static const Color textMain = Color(0xFFF3F4F6);
  static const Color textMuted = Color(0xFF9CA3AF);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: accentBlue,
      cardColor: cardBg,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentPink,
        surface: cardBg,
        error: accentPink,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.outfit(
          color: textMain,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: textMain,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: textMain,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textMain,
          fontSize: 14,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textMuted,
          fontSize: 12,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF101014),
        selectedItemColor: accentBlue,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
