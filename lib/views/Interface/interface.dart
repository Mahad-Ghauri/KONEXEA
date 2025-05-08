// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/Views/Interface/profile/profile_page.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Interface/chat_page.dart';
import 'package:social_swap/views/Interface/feed_page.dart';
import 'package:social_swap/views/Interface/news_page.dart';
import 'package:social_swap/views/Interface/upload_page.dart';

class InterfacePage extends StatefulWidget {
  static const String id = 'InterfacePage';
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  final bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedPage(),
    const UploadPage(),
    const NewsPage(),
    const ProfileScreen(),
  ];

  final AuthenticationController _authController = AuthenticationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        buttonBackgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
        color: Theme.of(context).colorScheme.primary,
        animationDuration: const Duration(milliseconds: 350),
        items: [
          Icon(Iconsax.home, color: Theme.of(context).colorScheme.surface),
          Icon(Iconsax.add_circle,
              color: Theme.of(context).colorScheme.surface),
          Icon(Icons.public, color: Theme.of(context).colorScheme.surface),
          Icon(Iconsax.user, color: Theme.of(context).colorScheme.surface),
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
