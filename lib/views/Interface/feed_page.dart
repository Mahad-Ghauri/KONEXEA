import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/controllers/Services/Database/feed_services.dart';
import 'package:social_swap/views/components/post_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
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
  bool _showScrollToTop = false;

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

    // Scroll controller listener for "scroll to top" button
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTop = _scrollController.offset > 500;
      });
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
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Custom Stories bar
                buildStoriesSection(context),

                // Divider
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary.withOpacity(0.1),
                  thickness: 1,
                ),

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

          // Floating scroll to top button
          if (_showScrollToTop)
            Positioned(
              right: 16,
              bottom: 80,
              child: AnimatedOpacity(
                opacity: _showScrollToTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: FloatingActionButton.small(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutQuint,
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 4,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildStoriesSection(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Add story button
          Column(
            children: [
              Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                child: Center(
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add Story',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Example stories (you can populate these from actual user data)
          ...List.generate(
            8,
            (index) => buildStoryItem(
              context,
              'User ${index + 1}',
              'https://source.unsplash.com/random/200x200?sig=$index',
              index % 3 == 0, // Some viewed, some not
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStoryItem(
    BuildContext context,
    String username,
    String imageUrl,
    bool viewed,
  ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  viewed
                      ? [Colors.grey, Colors.grey.shade400]
                      : [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                        Colors.purple,
                        Colors.orange,
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          username.length > 8 ? '${username.substring(0, 8)}...' : username,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: viewed ? Colors.grey : null,
          ),
        ),
      ],
    );
  }

  Widget buildLoadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder:
            (_, __) => Padding(
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
                  child: Icon(
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
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Iconsax.add_circle),
            label: Text(
              'Create Post',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
            ),
          ),
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
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: feedService.posts.length,
        itemBuilder: (context, index) {
          final post = feedService.posts[index];

          // Add a divider or section header for days
          Widget divider = const SizedBox.shrink();
          if (index > 0) {
            final DateTime currentPostDate =
                post['timeStamp'] ?? DateTime.now();
            final DateTime previousPostDate =
                feedService.posts[index - 1]['timeStamp'] ?? DateTime.now();

            if (currentPostDate.day != previousPostDate.day) {
              divider = Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _formatDateHeader(currentPostDate),
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiary.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              );
            }
          }

          return Column(
            children: [
              divider,
              PostCard(
                imageUrl: post['image'] ?? '',
                description: post['description'] ?? '',
                timestamp: post['timeStamp'] ?? DateTime.now(),
                postId: post['postId'] ?? '',
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
