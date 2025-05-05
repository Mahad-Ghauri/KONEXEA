// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Interface/Profile/about_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:social_swap/views/Interface/profile/edit_profile_page.dart';
import 'package:social_swap/views/Interface/profile/security_center_page.dart';
import 'package:social_swap/views/Interface/profile/help_center_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final AuthenticationController authController =
        AuthenticationController(); // Create an instance of the controller

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            // leading: IconButton(
            //   icon: const Icon(Iconsax.arrow_left_2),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFFDD0),
                      const Color(0xFFFFFDD0).withOpacity(0.8)
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Icon(
                            Iconsax.user,
                            size: 40,
                            color: Color(0xFF228B22),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? 'Guest User',
                        style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.of(context).push(
                        _elegantRoute(const EditProfilePage()),
                      );
                    },
                  ),
                  _buildProfileTile(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    onTap: () {
                      Navigator.of(context).push(
                        _elegantRoute(const SecurityCenterPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {
                      Navigator.of(context).push(
                        _elegantRoute(const HelpCenterPage()),
                      );
                    },
                  ),
                  _buildProfileTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.of(context).push(
                          _elegantRoute(const AboutPage()),
                        );
                      }),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => authController
                          .signOutAndEndSession(context)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green.shade700,
                            content: Text(
                              "Hope to see you soon!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                              ),
                            ),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red.shade700,
                            content: Text(
                              "Error Occurred: $error",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                              ),
                            ),
                          ),
                        );
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1C1C1C),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF556B2F).withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF228B22)),
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF228B22)),
        onTap: onTap,
      ),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation =
            Tween<double>(begin: 0, end: 0.9).animate(animation);
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
