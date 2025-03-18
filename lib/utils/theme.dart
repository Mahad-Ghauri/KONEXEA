import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily, // urbanist
  colorScheme: ColorScheme.light(
    surface: Color(0xFF000000),
    tertiary: Color(0xFFE8D4B9),
    secondary: Color(0xFF1E3E62),
    primary: Color(0xFFFF6500),
  ),
);
