// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Container(
        height: 400,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      ),
    );
  }
}
