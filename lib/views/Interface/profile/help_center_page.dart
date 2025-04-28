import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to the Security Center and use the change password option.'
    },
    {
      'question': 'How do I contact support?',
      'answer':
          'Use the Contact Us section below or email us at support@socialswap.com.'
    },
    {
      'question': 'How do I edit my profile?',
      'answer':
          'Go to Edit Profile from your profile page to update your information.'
    },
  ];

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@socialswap.com',
      query: 'subject=App Support Request',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center', style: GoogleFonts.urbanist()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('Frequently Asked Questions',
              style: GoogleFonts.urbanist(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...faqs.map((faq) => ExpansionTile(
                title: Text(faq['question']!,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(faq['answer']!, style: GoogleFonts.urbanist()),
                  ),
                ],
              )),
          const SizedBox(height: 32),
          Text('Contact Us',
              style: GoogleFonts.urbanist(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('If you have any issues or feedback, feel free to reach out:',
              style: GoogleFonts.urbanist()),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _launchEmail,
            icon: const Icon(Icons.email),
            label: const Text('Email Support'),
          ),
        ],
      ),
    );
  }
}
