import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily, // urbanist
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFDD0),
    primary: Color(0xFF228B22),
    // secondary: Color(0xFF1E3E62),
    tertiary: Color(0xFF1C1C1C),
  ),
);
