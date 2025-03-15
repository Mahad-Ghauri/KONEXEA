import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily, // urbanist
  colorScheme: ColorScheme.light(
    surface: Color(0xFFFFFDD0),
    tertiary: Color(0xFFE8D4B9),
    secondary: Colors.black,
    primary: Color(0xFF606C38),
  ),
);
