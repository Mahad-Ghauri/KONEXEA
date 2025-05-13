import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final Widget content;
  const AuthCard({super.key,required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withAlpha(204),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: content,
        ),
      ),
    );
  }
}