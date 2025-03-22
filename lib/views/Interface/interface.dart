// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Authentication/login.dart';
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

  int _page = 0;

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
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.infinity,
                      blendMode: BlendMode.dstOut,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: height * 0.06,
                    ),
                    Text(
                      'Social Swap',
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.home,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              onTap: () {
                setState(() => _page = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Upload',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              onTap: () {
                setState(() => _page = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.public,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'News',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              onTap: () {
                setState(() => _page = 2);
                Navigator.pop(context);
              },
            ),
            Spacer(flex: 20),
            Divider(color: Theme.of(context).colorScheme.tertiary),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.setting_2,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings page
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.info_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'About',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to about page
              },
            ),
            Divider(color: Theme.of(context).colorScheme.tertiary),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: height * 0.02),
                subtitle: Text(
                  "See You Again Soon!",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                  ),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.logout,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Close drawer first

                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          'Sign Out',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to sign out?',
                          style: GoogleFonts.urbanist(color: Colors.grey[700]),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.urbanist(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Sign Out',
                              style: GoogleFonts.urbanist(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm != true) return;

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final success =
                        await _authController.signOutCurrentSession();
                    if (success && mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        _elegantRoute(LoginPage()),
                        (route) => false,
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to sign out. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('An error occurred while signing out.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
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
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // animationCurve: Curves.easeInCirc,
        buttonBackgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.surface,
        animationDuration: Duration(milliseconds: 400),
        items: [
          Icon(Iconsax.home, color: Colors.white),
          Icon(Iconsax.add_circle, color: Colors.white),
          Icon(Icons.public, color: Colors.white),
        ],
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
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
