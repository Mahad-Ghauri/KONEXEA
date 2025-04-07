import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';

class PHubInterface extends StatefulWidget {
  const PHubInterface({super.key});

  @override
  State<PHubInterface> createState() => _PHubInterfaceState();
}

class _PHubInterfaceState extends State<PHubInterface>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          spacing: 15,
          children: [
            Icon(
              FontAwesomeIcons.infinity,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'Products Hub',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                letterSpacing: 1.5,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Text(
              "Explore the latest products and trends",
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: MediaQuery.sizeOf(context).height * 0.034,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
