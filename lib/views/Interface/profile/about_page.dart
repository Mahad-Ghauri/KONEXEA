// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/views/components/Profile/about_components.dart';
// ignore: depend_on_referenced_packages
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
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
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          "v1.2.0",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // App description
                AboutComponents.buildSectionTitle(context, "About Social Swap"),
                AboutComponents.buildCard(
                  context,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Social Swap is a modern social media application that combines the power of AI with social networking. Share your thoughts, connect with others, and interact with our intelligent AI chatbot.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: GoogleFonts.outfit().fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Features
                AboutComponents.buildSectionTitle(context, "Key Features"),
                AboutComponents.buildCard(
                  context,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        AboutComponents.buildFeatureItem(
                          icon: Icons.person,
                          title: "User Authentication",
                          description: "Secure login and registration system",
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildFeatureItem(
                          icon: Icons.chat_bubble,
                          title: "AI Chat Assistant",
                          description:
                              "Intelligent chatbot powered by Gemini AI",
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildFeatureItem(
                          icon: Icons.feed,
                          title: "Social Feed",
                          description: "Share and interact with posts",
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildFeatureItem(
                          icon: Icons.image,
                          title: "Image Sharing",
                          description:
                              "Upload and share images with your posts",
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildFeatureItem(
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
                AboutComponents.buildSectionTitle(context, "Technologies Used"),
                AboutComponents.buildCard(
                  context,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AboutComponents.buildTechItem(
                                icon: Icons.flutter_dash,
                                title: "Flutter",
                                context: context,
                              ),
                            ),
                            Expanded(
                              child: AboutComponents.buildTechItem(
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
                              child: AboutComponents.buildTechItem(
                                icon: Icons.storage_rounded,
                                title: "Supabase",
                                context: context,
                              ),
                            ),
                            Expanded(
                              child: AboutComponents.buildTechItem(
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
                              child: AboutComponents.buildTechItem(
                                icon: Icons.lock,
                                title: "Auth",
                                context: context,
                              ),
                            ),
                            Expanded(
                              child: AboutComponents.buildTechItem(
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
                AboutComponents.buildSectionTitle(context, "Developer"),
                AboutComponents.buildCard(
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
                                  "MM",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mahateer Muhammad",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.outfit().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Flutter Developer",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary
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
                const SizedBox(height: 15),
                // Developer 2
                AboutComponents.buildCard(
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                      fontFamily:
                                          GoogleFonts.outfit().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Flutter Developer",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary
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

                const SizedBox(height: 15),
                AboutComponents.buildSectionTitle(context, "Contact Us"),
                // Contact
                AboutComponents.buildCard(
                  context,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        AboutComponents.buildContactItem(
                          icon: Icons.email,
                          title: "Email",
                          value: "Mahateermuhammad100@gmail.com",
                          onTap: () => _launchUrl(
                              "mailto:Mahateermuhammad100@gmail.com"),
                          context: context,
                        ),
                        AboutComponents.buildContactItem(
                          icon: Icons.email,
                          title: "Email",
                          value: "mahadghauri222@gmail.com",
                          onTap: () =>
                              _launchUrl("mailto:mahadghauri222@gmail.com"),
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildContactItem(
                          icon: Icons.public,
                          title: "GitHub",
                          value: "https://github.com/Mahad-Ghauri",
                          onTap: () => _launchUrl(
                              "https://github.com/Mahad-Ghauri/Social-Swap-Main"),
                          context: context,
                        ),
                        const Divider(),
                        AboutComponents.buildContactItem(
                          icon: Iconsax.instagram,
                          title: "Instagram",
                          value: "@_m_muhammad_4",
                          onTap: () => _launchUrl(
                              "https://www.instagram.com/__m_muhammad_4?igsh=MTZvcG96MXZkbzZsbQ=="),
                          context: context,
                        ),
                        AboutComponents.buildContactItem(
                          icon: Iconsax.instagram,
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
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.7),
                      fontFamily: GoogleFonts.outfit().fontFamily,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Made with ❤️ by Mahateer Muhammad & Mahad Ghauri",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.7),
                      fontFamily: GoogleFonts.outfit().fontFamily,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
