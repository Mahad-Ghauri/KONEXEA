// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Authentication/login.dart';
import 'package:social_swap/views/Interface/drawer_page.dart';
import 'package:social_swap/views/Interface/feed_page.dart';
import 'package:social_swap/views/Interface/news_page.dart';
import 'package:social_swap/views/Interface/upload_page.dart';
import 'package:social_swap/views/Interface/about_page.dart';

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
          spacing: 15,
          children: [
            Icon(
              FontAwesomeIcons.infinity,
              color: Theme.of(context).colorScheme.primary,
            ),
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
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.surface,
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(Iconsax.home, color: Colors.white),
          Icon(Iconsax.add_circle, color: Colors.white),
          Icon(Icons.public, color: Colors.white),
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

  PageRouteBuilder _elegantRoute(Widget page, String tag) {
    return PageRouteBuilder(
      settings: RouteSettings(name: tag),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
