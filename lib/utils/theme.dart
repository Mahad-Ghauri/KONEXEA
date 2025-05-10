// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Enhanced light mode theme with more complete color scheme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily,
  colorScheme: ColorScheme.light(
    // Primary brand color
    primary: const Color(0xFF00A19A), // Enhanced teal
    onPrimary: Colors.white,
    // Secondary accent color
    secondary: const Color(0xFF4CAF50), // Vibrant green
    onSecondary: Colors.white,
    // Tertiary accent color
    tertiary: const Color(0xFF1C1C1C), // Dark for text
    onTertiary: Colors.white,
    // Background colors
    background: Colors.grey[50]!,
    onBackground: const Color(0xFF1C1C1C),
    // Surface colors for cards and elevated components
    surface: Colors.white,
    onSurface: const Color(0xFF1C1C1C),
    // Error colors
    error: const Color(0xFFE53935),
    onError: Colors.white,
    // Custom surface tint for subtle elevation effects
    surfaceTint: const Color(0xFF00A19A).withOpacity(0.05),
  ),
  // Enhanced card theme
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAlias,
  ),
  // Enhanced button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  // Enhanced input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF00A19A), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  // Enhanced text theme
  textTheme: TextTheme(
    displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.outfit(fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.outfit(fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.outfit(),
    bodyMedium: GoogleFonts.outfit(),
    bodySmall: GoogleFonts.outfit(),
    labelLarge: GoogleFonts.outfit(fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.outfit(),
    labelSmall: GoogleFonts.outfit(),
  ),
  // Enhanced app bar theme
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: const Color(0xFF1C1C1C),
    centerTitle: false,
    titleTextStyle: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1C1C1C),
    ),
  ),
);
