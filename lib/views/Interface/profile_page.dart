import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.italiana(
            color: Theme.of(context).colorScheme.primary,
            fontSize: height * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: height * 0.05,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.person, size: 40),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'User Name',
                    style: GoogleFonts.urbanist(
                      fontSize: height * 0.024,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    '@username',
                    style: GoogleFonts.urbanist(
                      color: Colors.grey,
                      fontSize: height * 0.016,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(context, 'Posts', '123', height),
                      _buildStatColumn(context, 'Followers', '1.2K', height),
                      _buildStatColumn(context, 'Following', '890', height),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.urbanist(fontSize: height * 0.016),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: height * 0.02),
            _buildProfileSection(context, 'My Posts', Icons.grid_on, height),
            _buildProfileSection(
              context,
              'Saved Posts',
              Icons.bookmark_outline,
              height,
            ),
            _buildProfileSection(
              context,
              'Settings',
              Icons.settings_outlined,
              height,
            ),
            _buildProfileSection(
              context,
              'Help & Support',
              Icons.help_outline,
              height,
            ),
            _buildProfileSection(
              context,
              'Logout',
              Icons.logout,
              height,
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String count,
    double height,
  ) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.urbanist(
            fontSize: height * 0.02,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: height * 0.014,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    String title,
    IconData icon,
    double height, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: height * 0.016,
          color: isLogout ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (isLogout) {
          // Handle logout
        }
      },
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
