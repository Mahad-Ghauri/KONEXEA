// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/Views/Interface/profile/profile_page.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Interface/chat_page.dart';
import 'package:social_swap/views/Interface/drawer_page.dart';
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
  bool _isLoading = false;
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: DrawerPage(
        onPageSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentPage: _selectedIndex,
        authController: _authController,
        isLoading: _isLoading,
        setLoading: (value) {
          setState(() {
            _isLoading = value;
          });
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.infinity,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 15),
            Text(
              'Social Swap',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: height * 0.024,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontFamily: GoogleFonts.lobsterTwo().fontFamily,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Iconsax.message_2,
                  color: Color(0xFF228B22),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.surface,
        animationDuration: const Duration(milliseconds: 350),
        items: [
          Icon(Iconsax.home, color: Theme.of(context).colorScheme.primary),
          Icon(Iconsax.add_circle,
              color: Theme.of(context).colorScheme.primary),
          Icon(Icons.public, color: Theme.of(context).colorScheme.primary),
          Icon(Iconsax.user, color: Theme.of(context).colorScheme.primary),
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
