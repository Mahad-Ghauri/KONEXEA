// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:Konexea/Views/Interface/Profile/saved_posts_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/controllers/Services/Authentication/authentication_controller.dart';
import 'package:Konexea/Controllers/Services/User Profile/user_profile_service.dart';
import 'package:Konexea/Views/Components/profile_image_widget.dart';
import 'package:Konexea/views/Interface/Profile/about_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Konexea/views/Interface/profile/edit_profile_page.dart';
import 'package:Konexea/views/Interface/profile/security_center_page.dart';
import 'package:Konexea/views/Interface/profile/help_center_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  
  @override
  void initState() {
    super.initState();
    // Initialize user profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileService>(context, listen: false).initializeUserProfile();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Profile page'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: height * 0.024,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontFamily: GoogleFonts.lobsterTwo().fontFamily,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
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
                          padding: EdgeInsets.all(4.0),
                          child: ProfileImageWidget(
                            size: 100,
                            isEditable: false,
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
                  _buildProfileTile(
                    icon: Icons.bookmark_outlined,
                    title: 'Saved Posts',
                    onTap: () {
                      Navigator.of(context).push(
                        _elegantRoute(const SavedPostsPage()),
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
                      onPressed: () => _authController
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
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.teal),
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
