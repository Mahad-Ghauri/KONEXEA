// ignore_for_file: deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Feed%20Database/feed_services.dart';
import 'package:social_swap/Views/Components/Feed/feed_ui_components.dart';
import 'package:social_swap/Views/Components/custom_app_bar.dart';
import 'package:social_swap/Views/Components/pulsating_widget.dart';
import 'package:social_swap/Views/Interface/Chat/chat_page.dart';
import 'package:social_swap/Views/Interface/Comments/comment_dialog.dart';
import 'package:social_swap/Views/Interface/PHub/phub_interface.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_swap/views/Interface/Chat Bot/chatbot_page.dart';
import 'dart:math' as math;
import 'dart:async'; // For periodic animations
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:photo_view/photo_view.dart'; // For image zoom
import 'package:video_player/video_player.dart'; // For video playback
// import 'package:visibility_  detector/visibility_detector.dart'; // For autoplay

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _expandedPosts = {};
  final Map<String, bool> _likedPosts = {};
  final Map<String, int> _likeCount = {};
  final Map<String, VideoPlayerController?> _videoControllers = {};
  final Map<String, bool> _videoInitialized = {};
  late AnimationController _fabAnimationController;
  bool _showFabs = true;
  // Timer? _scrollEndTimer;

  // Animation for refreshing
  late final AnimationController _refreshAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  /*late final Animation<double> _refreshAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: _refreshAnimationController, curve: Curves.easeOut));*/

  @override
  void initState() {
    super.initState();
    // Animation for loading and empty state
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Animation for FAB appearance/disappearance
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0, // Start visible
    );

    // Fetch posts when the page loads
    Future.microtask(() {
      Provider.of<FeedServices>(context, listen: false).fetchPosts().then((_) {
        _initializeVideoControllers();
      });
    });

    // Initialize like counts
    _initializeLikeCounts();

    // Add scroll listener for scroll animations
    _scrollController.addListener(_scrollListener);
  }

  void _initializeVideoControllers() {
    final feedService = Provider.of<FeedServices>(context, listen: false);
    for (var post in feedService.posts) {
      if (post['videoUrl'] != null) {
        String postId = post['postId'] ?? '';
        _videoControllers[postId] =
            VideoPlayerController.network(post['videoUrl'])
              ..initialize().then((_) {
                if (mounted) {
                  setState(() {
                    _videoInitialized[postId] = true;
                  });
                }
              });
        _videoInitialized[postId] = false;
      }
    }
  }

  void _scrollListener() {
    // Implement scroll animations or effects
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more posts when reaching the bottom
      // _loadMorePosts();
    }

    // Hide/show FABs based on scroll direction
    if (_scrollController.position.isScrollingNotifier.value) {
      if (_showFabs) {
        setState(() {
          _showFabs = false;
        });
        _fabAnimationController.reverse();
      }
    } else {
      if (!_showFabs) {
        setState(() {
          _showFabs = true;
        });
        _fabAnimationController.forward();
      }
    }
  }

  // void _loadMorePosts() {
  //   // Add logic to load more posts
  //   Provider.of<FeedServices>(context, listen: false).loadMorePosts();
  // }

  void _initializeLikeCounts() {
    // Initialize like counts from the service
    Future.delayed(Duration.zero, () {
      final feedService = Provider.of<FeedServices>(context, listen: false);
      if (feedService.posts.isNotEmpty) {
        for (var post in feedService.posts) {
          final postId = post['postId'] ?? '';
          _likeCount[postId] = feedService.getLikeCount(postId);
          _likedPosts[postId] = feedService.isPostLikedByCurrentUser(postId);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _refreshAnimationController.dispose();

    // Dispose video controllers
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }

    super.dispose();
  }

  Future<void> _handleLikePost(String postId) async {
    // Haptic feedback for better interaction
    HapticFeedback.mediumImpact();

    final feedService = Provider.of<FeedServices>(context, listen: false);
    final isLiked = await feedService.toggleLikePost(postId);

    setState(() {
      _likedPosts[postId] = isLiked;
    });

    // If the post was liked (not unliked), briefly show the animation
    if (isLiked) {
      // Reset the animation after 1 second
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            // Only reset the animation state, not the actual like state
            _likedPosts[postId] = feedService.isPostLikedByCurrentUser(postId);
          });
        }
      });
    }
  }

  // Then update the _handleDoubleTapLike method to control the animation timing:
  Future<void> _handleDoubleTapLike(String postId) async {
    final feedService = Provider.of<FeedServices>(context, listen: false);
    final isCurrentlyLiked = feedService.isPostLikedByCurrentUser(postId);

    if (!isCurrentlyLiked) {
      // Haptic feedback for better interaction
      HapticFeedback.mediumImpact();

      // Show heart animation immediately
      setState(() {
        _likedPosts[postId] = true;
      });

      // Actually like the post in the database
      await feedService.toggleLikePost(postId);

      // Hide the heart animation after a short delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            // Only reset the animation state, the actual like remains
            _likedPosts[postId] = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    int _selectedIndex = 0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Social Swap',
        centerTitle: false,
        showBackButton: false,
        titleWidget: Text(
          'Social Swap',
          style: GoogleFonts.lobsterTwo(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: height * 0.024,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        enableShadow: true,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Iconsax.message_2,
                    color: Color(0xFF228B22),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
              },
            ),
          if (_selectedIndex == 0) const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Enhanced background gradient with subtle pattern
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
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary.withOpacity(0.03),
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.overlay,
              child: Container(
                color: Colors.transparent,
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
                        return buildEnhancedLoadingShimmer(context);
                      }

                      if (feedService.posts.isEmpty) {
                        return buildEnhancedEmptyState(context);
                      }

                      return buildEnhancedPostsList(context, feedService);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Enhanced floating action buttons with animations
          buildFloatingActionButton(
            icon: Icons.smart_toy_outlined,
            color: Colors.white70,
            onPressed: () {
              Navigator.of(context).push(_elegantRoute(const ChatbotPage()));
            },
          ),
          const SizedBox(height: 10),
          buildFloatingActionButton(
            icon: Icons.shopping_bag_rounded,
            color: Colors.white70,
            hasBorder: true,
            onPressed: () {
              Navigator.of(context)
                  .push(_elegantRoute(const PHubInterfacePage()));
            },
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(
      BuildContext context, String postId, String posterUsername) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: CommentDialog(
          postId: postId,
          posterUsername: posterUsername,
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Post',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  icon: Iconsax.message,
                  label: 'Message',
                  color: Colors.blue,
                ),
                _buildShareOption(
                  context,
                  icon: Iconsax.global,
                  label: 'Browser',
                  color: Colors.orange,
                ),
                _buildShareOption(
                  context,
                  icon: Iconsax.copy,
                  label: 'Copy',
                  color: Colors.purple,
                ),
                _buildShareOption(
                  context,
                  icon: Iconsax.more_square,
                  label: 'More',
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing via $label'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Post',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this post?',
              style: GoogleFonts.urbanist(),
            ),
            const SizedBox(height: 20),
            ...['Inappropriate content', 'Spam', 'Misinformation', 'Other']
                .map(
                  (reason) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(reason),
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your report'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                )
                // ignore: unnecessary_to_list_in_spreads
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool hasBorder = false,
    Color borderColor = Colors.transparent,
    double size = 56.0,
    double iconSize = 24.0,
    double elevation = 4.0,
    Curve animationCurve = Curves.easeOutQuart,
    Duration animationDuration = const Duration(milliseconds: 300),
    List<BoxShadow>? customShadows,
    bool enablePulseAnimation = false,
    Color? splashColor,
    Color? backgroundColor,
  }) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      child: PulsatingWidget(
        enabled: enablePulseAnimation,
        child: SizedBox(
          width: size,
          height: size,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            backgroundColor: backgroundColor ??
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
            elevation: elevation,
            splashColor: splashColor ?? color.withOpacity(0.3),
            highlightElevation: elevation + 2,
            onPressed: () {
              HapticFeedback.lightImpact();
              onPressed();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    hasBorder ? Border.all(color: borderColor, width: 2) : null,
                boxShadow: customShadows,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    icon,
                    color: color,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEnhancedLoadingShimmer(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) {
        // Staggered animation delay based on index
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1.0,
          curve: Curves.easeOut,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
            highlightColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
            period: Duration(milliseconds: 1000 + (index * 100)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
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
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 80,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 200 + (index * 20) % 100, // Varied heights
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          3,
                          (lineIndex) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              width: double.infinity - (lineIndex * 20),
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Action buttons shimmer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (i) => Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEnhancedEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                height: 150,
                width: 150,
                child: Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        startAngle: 0,
                        endAngle: math.pi * 2,
                        transform: GradientRotation(
                            _animationController.value * 2 * math.pi),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.gallery_add,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'No posts yet',
            style: GoogleFonts.urbanist(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Be the first to share something amazing with your community!',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Add navigation to create post page
              HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            icon: const Icon(Iconsax.add_circle),
            label: Text(
              'Create Post',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnhancedPostsList(
      BuildContext context, FeedServices feedService) {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshAnimationController.forward(from: 0.0);
        await feedService.fetchPosts();
        _refreshAnimationController.reverse();
      },
      displacement: 20,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: feedService.posts.length,
        itemBuilder: (context, index) {
          final post = feedService.posts[index];
          final postId = post['postId'] ?? '';
          final isExpanded = _expandedPosts[postId] ?? false;
          // Get email from post and extract username part (before @)
          final String fullEmail = post['userEmail'] ?? 'Anonymous';
          final String posterUsername =
              fullEmail.contains('@') ? fullEmail.split('@')[0] : fullEmail;
          final isLiked = _likedPosts[postId] ?? false;

          // Create staggered animations based on index
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            curve: Curves.easeOut,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: ModalRoute.of(context)?.animation ??
                    AnimationController(vsync: this, duration: Duration.zero),
                curve: Interval(
                  (index / 20).clamp(0.0, 0.9),
                  ((index + 1) / 20).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced post header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Profile avatar with decoration
                            Container(
                              width: 40,
                              height: 40,
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
                              child: const Center(
                                child: Icon(
                                  Icons.person_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mail,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          posterUsername, // Use the email from the post
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Iconsax.tick_circle,
                                        size: 14,
                                        color: Colors.teal,
                                      )
                                    ],
                                  ),
                                  Text(
                                    _formatTimestamp(
                                      post['timeStamp'] ?? DateTime.now(),
                                    ),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.more),
                              onPressed: () {
                                // Show post options
                                _showPostOptions(context, post);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Enhanced post image with double-tap like
                      if (post['image'] != null)
                        GestureDetector(
                          onDoubleTap: () => _handleDoubleTapLike(postId),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Hero image for transitions
                              Hero(
                                tag: 'post_image_$postId',
                                child: CachedNetworkImage(
                                  imageUrl: post['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 400,
                                  placeholder: (context, url) => Container(
                                    height: 400,
                                    color: Colors.grey.withOpacity(0.1),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 400,
                                    color: Colors.grey.withOpacity(0.1),
                                    child: const Center(
                                      child:
                                          Icon(Icons.error_outline, size: 50),
                                    ),
                                  ),
                                ),
                              ),

                              // Instagram-style pop-up heart animation
                              Consumer<FeedServices>(
                                builder: (context, feedService, _) {
                                  final isLiked = _likedPosts[postId] ?? false;
                                  return AnimatedScale(
                                    scale: isLiked ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.elasticOut,
                                    child: AnimatedOpacity(
                                      opacity: isLiked ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.teal,
                                        size: 100,
                                        shadows: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      // Enhanced post description
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['description'] ?? '',
                              maxLines: isExpanded ? null : 3,
                              overflow:
                                  isExpanded ? null : TextOverflow.ellipsis,
                              style: GoogleFonts.urbanist(
                                color: Theme.of(context).colorScheme.tertiary,
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                            if ((post['description'] ?? '').length > 150)
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _expandedPosts[postId] = !isExpanded;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.centerLeft,
                                ),
                                child: Text(
                                  isExpanded ? 'Show less' : 'Read more',
                                  style: GoogleFonts.urbanist(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Add interaction buttons (like, comment, share)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // Like button
                            Consumer<FeedServices>(
                              builder: (context, feedService, _) {
                                final isLiked = feedService
                                    .isPostLikedByCurrentUser(postId);
                                final likeCount =
                                    feedService.getLikeCount(postId);
                                return _buildInteractionButton(
                                  icon: isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  label: _formatCount(likeCount),
                                  onPressed: () => _handleLikePost(postId),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            // Comment button
                            Consumer<FeedServices>(
                              builder: (context, feedService, _) {
                                final commentCount =
                                    feedService.comments[postId]?.length ?? 0;
                                return _buildInteractionButton(
                                  icon: Iconsax.message,
                                  label: _formatCount(commentCount),
                                  onPressed: () {
                                    // Open comments as bottom sheet
                                    HapticFeedback.lightImpact();
                                    _showCommentsBottomSheet(
                                        context, postId, posterUsername);
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            // Share button
                            _buildInteractionButton(
                              icon: Iconsax.send_1,
                              onPressed: () {
                                // Share post
                                HapticFeedback.lightImpact();
                              },
                            ),
                            const Spacer(),
                            // Bookmark button
                            IconButton(
                              icon: const Icon(Iconsax.bookmark),
                              onPressed: () {
                                // Bookmark post
                                HapticFeedback.lightImpact();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    String? label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: color ?? Theme.of(context).colorScheme.tertiary,
            ),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context, Map<String, dynamic> post) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                _buildOptionItem(
                  icon: Iconsax.save_2,
                  label: 'Save Post',
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    // Logic to save post
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Post saved to collection'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Iconsax.copy,
                  label: 'Copy Link',
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    // Logic to copy post link
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Link copied to clipboard!'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Iconsax.share,
                  label: 'Share Post',
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    // Logic to share post
                    _showShareOptions(context);
                  },
                ),
                _buildOptionItem(
                  icon: Iconsax.notification,
                  label: 'Turn on Post Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    // Logic to turn on notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Post notifications turned on'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Iconsax.flag,
                  label: 'Report Post',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    // Logic to report post
                    _showReportDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(
        label,
        style: GoogleFonts.urbanist(
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.tertiary,
        ),
      ),
      onTap: onTap,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Route _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
