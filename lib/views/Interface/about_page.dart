// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "About Us",
              style: TextStyle(
                fontFamily: GoogleFonts.urbanist().fontFamily,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo and name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.swap_calls,
                          size: 70,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Social Swap",
                      style: TextStyle(
                        fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      "Connect, Share, and Chat with AI",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.7),
                        fontFamily: GoogleFonts.outfit().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "v1.0.0",
                        style: TextStyle(
                          color: Color(0xFF1E3E62),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // App description
              _buildSectionTitle(context, "About Social Swap"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Social Swap is a modern social media application that combines the power of AI with social networking. Share your thoughts, connect with others, and interact with our intelligent AI chatbot.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: GoogleFonts.outfit().fontFamily,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Features
              _buildSectionTitle(context, "Key Features"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.person,
                        title: "User Authentication",
                        description: "Secure login and registration system",
                        context: context,
                      ),
                      const Divider(),
                      _buildFeatureItem(
                        icon: Icons.chat_bubble,
                        title: "AI Chat Assistant",
                        description: "Intelligent chatbot powered by Gemini AI",
                        context: context,
                      ),
                      const Divider(),
                      _buildFeatureItem(
                        icon: Icons.feed,
                        title: "Social Feed",
                        description: "Share and interact with posts",
                        context: context,
                      ),
                      const Divider(),
                      _buildFeatureItem(
                        icon: Icons.image,
                        title: "Image Sharing",
                        description: "Upload and share images with your posts",
                        context: context,
                      ),
                      const Divider(),
                      _buildFeatureItem(
                        icon: Icons.auto_awesome,
                        title: "Modern UI",
                        description: "Beautiful and responsive design",
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Technologies
              _buildSectionTitle(context, "Technologies Used"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.flutter_dash,
                              title: "Flutter",
                              context: context,
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.data_object,
                              title: "Dart",
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.storage_rounded,
                              title: "Supabase",
                              context: context,
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.psychology,
                              title: "Gemini AI",
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.lock,
                              title: "Auth",
                              context: context,
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.api,
                              title: "REST APIs",
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Developer
              _buildSectionTitle(context, "Developer"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "MG",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mahad Ghauri",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.outfit().fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Flutter Developer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle(context, "Contact Us"),
              // Contact
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildContactItem(
                        icon: Icons.email,
                        title: "Email",
                        value: "mahadghauri222@gmail.com",
                        onTap: () =>
                            _launchUrl("mailto:mahadghauri222@gmail.com"),
                        context: context,
                      ),
                      const Divider(),
                      _buildContactItem(
                        icon: Icons.public,
                        title: "GitHub",
                        value: "https://github.com/Mahad-Ghauri",
                        onTap: () => _launchUrl(
                            "https://github.com/Mahad-Ghauri/Social-Swap-Main"),
                        context: context,
                      ),
                      const Divider(),
                      _buildContactItem(
                        icon: Icons.camera_alt,
                        title: "Instagram",
                        value: "@_ghauri",
                        onTap: () =>
                            _launchUrl("https://www.instagram.com/_ghauri/#"),
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Copyright
              Center(
                child: Text(
                  "© 2024 Social Swap. All rights reserved.",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Made with ❤️ by Mahad Ghauri",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontFamily: GoogleFonts.outfit().fontFamily,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon,
                  color: Theme.of(context).colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.7)),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
