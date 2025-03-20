import 'package:flutter/material.dart';
import 'package:social_swap/views/components/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/background.jpeg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          ListView(
            children: [
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
            ],
          ),
        ],
      ),
    );
  }
}
