// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/controllers/Services/Database/feed_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_swap/views/Interface/PHub/phub_interface.dart';
import 'package:social_swap/views/Interface/chatbot_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' as math;

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _expandedPosts = {};

  @override
  void initState() {
    super.initState();
    // Animation for loading and empty state
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Fetch posts when the page loads
    Future.microtask(() {
      Provider.of<FeedServices>(context, listen: false).fetchPosts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Enhanced background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  Theme.of(context).colorScheme.surface.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Main feed content
                Expanded(
                  child: Consumer<FeedServices>(
                    builder: (context, feedService, _) {
                      if (feedService.loading) {
                        return buildLoadingShimmer(context);
                      }

                      if (feedService.posts.isEmpty) {
                        return buildEmptyState(context);
                      }

                      return buildPostsList(context, feedService);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.chat_outlined, color: Colors.black),
            onPressed: () {
              //  Navigate to Chatbot
              Navigator.of(context).push(_elegantRoute(const ChatbotPage()));
            },
          ),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.yellow.shade800,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(_elegantRoute(const PHubInterface()));
            },
          ),
        ],
      ),
    );
  }

  Widget buildLoadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 80,
                          height: 8,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * math.pi,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.gallery_add,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'No posts yet',
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share something amazing!',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     Navigator.of(context).push(_elegantRoute(const UploadPage()));
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //   ),
          //   icon: const Icon(Iconsax.add_circle),
          //   label: Text(
          //     'Create Post',
          //     style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildPostsList(BuildContext context, FeedServices feedService) {
    return RefreshIndicator(
      onRefresh: () => feedService.fetchPosts(),
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: feedService.posts.length,
        itemBuilder: (context, index) {
          final post = feedService.posts[index];
          final postId = post['postId'] ?? '';
          final isExpanded = _expandedPosts[postId] ?? false;
          final userEmail =
              Supabase.instance.client.auth.currentUser?.email ?? 'Anonymous';

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.mail,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    userEmail,
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Column(
                                    children: [
                                      Icon(
                                        Iconsax.tick_circle,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                _formatTimestamp(
                                  post['timeStamp'] ?? DateTime.now(),
                                ),
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Post image
                  if (post['image'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      child: Image.network(
                        post['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400,
                      ),
                    ),

                  // Post description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['description'] ?? '',
                          maxLines: isExpanded ? null : 3,
                          overflow: isExpanded ? null : TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.tertiary,
                            height: 1.5,
                          ),
                        ),
                        if ((post['description'] ?? '').length > 150)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _expandedPosts[postId] = !isExpanded;
                              });
                            },
                            child: Text(
                              isExpanded ? 'Show less' : 'Read more',
                              style: GoogleFonts.urbanist(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
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
