// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily, // urbanist
  colorScheme: const ColorScheme.light(
    primary: Colors.teal,
    surface: Colors.white,
    secondary: Color(0xFF556B2F),
    tertiary: Color(0xFF1C1C1C),
  ),
);
