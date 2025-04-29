// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/Views/Interface/Chat%20Bot/chatbot_page.dart';
import 'package:social_swap/Views/components/Profile/support_option_card.dart';
// import 'package:social_swap/Views/components/tutorial_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_swap/views/Interface/profile/security_center_page.dart';
import 'package:social_swap/views/Interface/profile/edit_profile_page.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> faqs = const [
    {
      'question': 'How do I reset my password?',
      'answer':
          'Go to the Security Center and use the change password option. You will receive a verification code via email to confirm your identity before setting a new password.'
    },
    {
      'question': 'How do I contact support?',
      'answer':
          'Use the Contact Us section below or email us at support@socialswap.com. Our support team is available 24/7 and typically responds within 2 business hours.'
    },
    {
      'question': 'How do I edit my profile?',
      'answer':
          'Go to Edit Profile from your profile page to update your information. You can change your profile picture, bio, username, and visibility settings.'
    },
    {
      'question': 'How do I delete my account?',
      'answer':
          'Navigate to Settings > Account > Delete Account. Please note that this action is irreversible and all your data will be permanently deleted after 30 days.'
    },
    {
      'question': 'How do I report inappropriate content?',
      'answer':
          'Tap the three dots on any post and select "Report". Fill in the required information to help our moderation team review the content quickly.'
    },
  ];

  final List<Map<String, dynamic>> tutorials = [
    {
      'title': 'Getting Started',
      'description': 'Learn the basics of using the app',
      'icon': Icons.play_circle_outline,
      'onTap': null,
    },
    {
      'title': 'Account Security',
      'description': 'Set up 2FA and protect your account',
      'icon': Icons.security,
      'onTap': (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SecurityCenterPage()),
        );
      },
    },
    {
      'title': 'Profile Customization',
      'description': 'Make your profile stand out',
      'icon': Icons.person_outline,
      'onTap': (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditProfilePage()),
        );
      },
    },
  ];

  final List<Map<String, dynamic>> supportOptions = [
    {
      'title': 'Email Support',
      'description': 'Get help via email',
      'icon': Icons.email_outlined,
      'action': 'email',
    },
    {
      'title': 'Live Chat',
      'description': 'Chat with a support agent',
      'icon': Icons.chat_bubble_outline,
      'action': 'chat',
    },
    {
      'title': 'Community Forum',
      'description': 'Browse community solutions',
      'icon': Icons.forum_outlined,
      'action': 'forum',
    },
  ];

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@socialswap.com',
      query: 'subject=App Support Request',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch email client',
                style: GoogleFonts.urbanist()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSupportAction(String action) {
    switch (action) {
      case 'email':
        _launchEmail();
        break;
      case 'chat':
        _showLiveChatModal();
        break;
      case 'forum':
        _navigateToForum();
        break;
    }
  }

  void _showLiveChatModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.headset_mic,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Live Chat Coming Soon',
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This feature will be available in the next update.',
                style: GoogleFonts.urbanist(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Close',
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToForum() {
    // This would navigate to a forum page in a real app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Community forum would open here',
            style: GoogleFonts.urbanist()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Map<String, String>> _getFilteredFaqs() {
    if (_searchController.text.isEmpty) return faqs;
    return faqs.where((faq) {
      return faq['question']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          faq['answer']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredFaqs = _getFilteredFaqs();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search for help...',
                  hintStyle: GoogleFonts.urbanist(),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.urbanist(),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : Text('Help Center',
                style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.urbanist(),
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.tertiary,
          tabs: [
            Tab(
              icon: Icon(Icons.question_answer,
                  color: _selectedTabIndex == 0
                      ? colorScheme.primary
                      : colorScheme.tertiary),
              text: 'FAQs',
            ),
            Tab(
              icon: Icon(Icons.school_outlined,
                  color: _selectedTabIndex == 1
                      ? colorScheme.primary
                      : colorScheme.tertiary),
              text: 'Tutorials',
            ),
            Tab(
              icon: Icon(Icons.contact_support,
                  color: _selectedTabIndex == 2
                      ? colorScheme.primary
                      : colorScheme.tertiary),
              text: 'Contact',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
              _tabController.index = index;
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FAQs Tab
          _isSearching && filteredFaqs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: GoogleFonts.urbanist(
                            fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try a different search term',
                        style: GoogleFonts.urbanist(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    if (!_isSearching) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Need help?',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Browse our FAQs below or search for specific topics',
                                    style: GoogleFonts.urbanist(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    ...filteredFaqs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final faq = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            childrenPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            leading: CircleAvatar(
                              backgroundColor:
                                  colorScheme.primary.withOpacity(0.1),
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.urbanist(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              faq['question']!,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            children: [
                              Text(
                                faq['answer']!,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.thumb_up_outlined,
                                        size: 16),
                                    label: Text('Helpful',
                                        style:
                                            GoogleFonts.urbanist(fontSize: 12)),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Thanks for your feedback!',
                                              style: GoogleFonts.urbanist()),
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),

          // Tutorials Tab
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: colorScheme.secondary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learn with Tutorials',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Watch step-by-step guides to master the app',
                            style: GoogleFonts.urbanist(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...tutorials.asMap().entries.map((entry) {
                final tutorial = entry.value;
                // final idx = entry.key;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: ListTile(
                    leading: Icon(
                      tutorial['icon'],
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      tutorial['title'],
                      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      tutorial['description'],
                      style: GoogleFonts.urbanist(),
                    ),
                    onTap: tutorial['onTap'] != null
                        ? () => tutorial['onTap'](context)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Opening tutorial: ${tutorial['title']}',
                                  style: GoogleFonts.urbanist(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                  ),
                );
              }),
            ],
          ),

          // Contact Tab
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.7),
                      colorScheme.secondary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need more help?',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our support team is ready to assist you with any issues or questions you might have.',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Contact Options',
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...supportOptions.map((option) => SupportOptionCard(
                    title: option['title'],
                    description: option['description'],
                    icon: option['icon'],
                    onTap: () => _handleSupportAction(option['action']),
                  )),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Operating Hours',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Monday - Friday: 9AM - 6PM ET',
                          style: GoogleFonts.urbanist(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Weekend: 10AM - 4PM ET',
                          style: GoogleFonts.urbanist(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Average Response Time: 2 hours',
                      style: GoogleFonts.urbanist(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Ask AI Assistant',
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
              content: Text(
                'Our AI assistant can help with quick questions. Would you like to start a conversation?',
                style: GoogleFonts.urbanist(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Not Now', style: GoogleFonts.urbanist()),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      _elegantRoute(
                        const ChatbotPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Start',
                      style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
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
