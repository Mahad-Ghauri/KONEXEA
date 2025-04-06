import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Authentication/login.dart';
import 'package:social_swap/views/Interface/about_page.dart';

class DrawerPage extends StatelessWidget {
  final Function(int) onPageSelected;
  final int currentPage;
  final AuthenticationController authController;
  final bool isLoading;
  final Function(bool) setLoading;

  const DrawerPage({
    super.key,
    required this.onPageSelected,
    required this.currentPage,
    required this.authController,
    required this.isLoading,
    required this.setLoading,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Drawer(
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
              onPageSelected(0);
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
              onPageSelected(1);
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
              onPageSelected(2);
              Navigator.pop(context);
            },
          ),
          const Spacer(flex: 20),
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
              // Navigator.pop(context);

              Navigator.of(context).push(
                _elegantRoute(const AboutPage()),
              );
              // Navigator.push(
              //   context,
              //   _elegantRoute(
              //     const AboutPage()
              //     // 'about_page_${DateTime.now().millisecondsSinceEpoch}',
              //   ),
              // );
            },
          ),
          Divider(color: Theme.of(context).colorScheme.tertiary),
          ListTile(
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                      style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.tertiary,
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

              setLoading(true);

              try {
                final success = await authController.signOutCurrentSession();
                if (success && context.mounted) {
                  Navigator.of(context).push(
                    _elegantRoute(const LoginPage()),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Failed to sign out. Please try again.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('An error occurred while signing out.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (context.mounted) {
                  setLoading(false);
                }
              }
            },
          ),
        ],
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
