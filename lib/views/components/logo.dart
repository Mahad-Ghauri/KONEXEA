import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.jpeg',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    );
  }
}
