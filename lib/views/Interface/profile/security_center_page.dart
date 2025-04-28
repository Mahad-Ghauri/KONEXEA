import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityCenterPage extends StatelessWidget {
  const SecurityCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Center', style: GoogleFonts.urbanist()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text('Security Center Page',
            style: GoogleFonts.urbanist(fontSize: 20)),
      ),
    );
  }
}
