// THEME LOCK: light — source: domain signal (healthcare, senior, outdoor readability)
// Scaffold.backgroundColor = AppTheme.backgroundLight — ALL screens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary palette — calm indigo, high-contrast accessible
  static const Color primary = Color(0xFF5B6BF8);
  static const Color primaryContainer = Color(0xFFE8EAFF);
  static const Color secondary = Color(0xFFA78BFA);
  static const Color secondaryContainer = Color(0xFFF3EEFF);

  // Semantic colors
  static const Color success = Color(0xFF2D7A4F);
  static const Color successContainer = Color(0xFFDCF5E7);
  static const Color warning = Color(0xFFB45309);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color errorColor = Color(0xFFB91C1C);
  static const Color errorContainer = Color(0xFFFFE4E4);
  static const Color emergencyRed = Color(0xFFD32F2F);

  // Specialty tint colors for cards
  static const Color mintTint = Color(0xFFD4EDE8);
  static const Color lavenderTint = Color(0xFFE8E8FF);
  static const Color peachTint = Color(0xFFFFECE8);
  static const Color skyTint = Color(0xFFE0F2FE);

  // Light surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF3F4FF);
  static const Color backgroundLight = Color(0xFFF7F8FF);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E2030);
  static const Color backgroundDark = Color(0xFF121420);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF1A1F6E),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF3B1F8A),
      surface: surfaceLight,
      onSurface: Color(0xFF1A1A2E),
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: Color(0xFF4A4A6A),
      error: errorColor,
      onError: Colors.white,
      errorContainer: errorContainer,
      onErrorContainer: Color(0xFF7F0000),
      outline: Color(0xFFBBBDD4),
      outlineVariant: Color(0xFFDDDEF0),
      inverseSurface: Color(0xFF2A2C3E),
      onInverseSurface: Color(0xFFF0F0FF),
      shadow: Color(0xFF000000),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.nunitoSansTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A6A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1A2E),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF4A4A6A),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF7A7A9A),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A6A),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF7A7A9A),
        ),
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: backgroundLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: primary,
      titleTextStyle: GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
      iconTheme: IconThemeData(color: Color(0xFF1A1A2E), size: 24),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFDDDEF0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A4A6A),
      ),
      hintStyle: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9E9EBE),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      floatingLabelStyle: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primary,
          );
        }
        return GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9EBE),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primary, size: 24);
        }
        return IconThemeData(color: Color(0xFF9E9EBE), size: 24);
      }),
      elevation: 4,
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        minimumSize: Size(double.infinity, 60),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        minimumSize: Size(double.infinity, 60),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariantLight,
      selectedColor: primary,
      labelStyle: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A4A6A),
      ),
      secondaryLabelStyle: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      side: BorderSide(color: Color(0xFFDDDEF0), width: 1),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: emergencyRed,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFFEEEFF8),
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF2A2C3E),
      contentTextStyle: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF8B9BFF),
      onPrimary: Color(0xFF1A1F6E),
      primaryContainer: Color(0xFF2D3580),
      onPrimaryContainer: Color(0xFFE8EAFF),
      secondary: Color(0xFFC4B5FD),
      onSecondary: Color(0xFF3B1F8A),
      surface: surfaceDark,
      onSurface: Color(0xFFE6E6FF),
      surfaceContainerHighest: Color(0xFF2A2C3E),
      onSurfaceVariant: Color(0xFFBBBDD4),
      error: Color(0xFFCF6679),
      onError: Colors.white,
      outline: Color(0xFF4A4A6A),
      outlineVariant: Color(0xFF2A2C3E),
      inverseSurface: Color(0xFFE6E6FF),
      onInverseSurface: Color(0xFF1A1A2E),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.nunitoSansTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Color(0xFFE6E6FF),
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE6E6FF),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE6E6FF),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFFE6E6FF),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFBBBDD4),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: Color(0xFF2D3580),
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
