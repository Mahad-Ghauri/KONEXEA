// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeDivider extends StatelessWidget {
  const CustomeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.white70.withOpacity(0.5), thickness: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Text(
            "OR",
            style: GoogleFonts.urbanist(
              color: Colors.white70,
              fontSize: height * 0.015,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1),
        ),
      ],
    );
  }
}
