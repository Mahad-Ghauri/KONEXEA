import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeDivider extends StatelessWidget {
  const CustomeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey.withAlpha(128), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "or",
            style: GoogleFonts.poppins(
              color: Colors.black45,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey.withAlpha(128), thickness: 1),
        ),
      ],
    );
  }
}