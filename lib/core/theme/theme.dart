import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color background = Color(0xFF0C0C0E);
  static const Color surface = Color(0xFF16161C);
  static const Color cardBg = Color(0x1Fffffff); // Glassmorphism translucent white
  static const Color cardBorder = Color(0x12ffffff);
  
  // Neon Accent Colors
  static const Color primaryNeon = Color(0xFF9D4EDD); // Electric Purple
  static const Color secondaryNeon = Color(0xFF00F5D4); // Neon Mint
  static const Color accentNeon = Color(0xFFFF007F); // Pink Sunset
  static const Color textPrimary = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFF8E909B);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryNeon,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        surface: surface,
        error: Color(0xFFFF4A4A),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Premium Glassmorphism Decoration Helper
  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    Color color = cardBg,
    Color borderColor = cardBorder,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Linear Neon Gradient Helper
  static Gradient get primaryGradient => const LinearGradient(
        colors: [primaryNeon, Color(0xFF7B2CBF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get accentGradient => const LinearGradient(
        colors: [accentNeon, Color(0xFFFF5E62)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      
  static Gradient get mintGradient => const LinearGradient(
        colors: [secondaryNeon, Color(0xFF00BBF9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
