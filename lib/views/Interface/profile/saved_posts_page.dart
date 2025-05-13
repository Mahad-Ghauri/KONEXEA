// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/Controllers/Services/Feed%20Database/feed_services.dart';
import 'package:Konexea/Controllers/Services/Feed%20Database/saved_post_services.dart';
import 'package:Konexea/Views/Components/custom_app_bar.dart';
import 'package:Konexea/Views/Interface/Comments/comment_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class SavedPostsPage extends StatefulWidget {
  const SavedPostsPage({super.key});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _expandedPosts = {};
  final Map<String, bool> _likedPosts = {};
  final Map<String, int> _likeCount = {};
  final Map<String, VideoPlayerController?> _videoControllers = {};
  final Map<String, bool> _videoInitialized = {};

  @override
  void initState() {
    super.initState();
    // Animation for loading and empty state
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Fetch saved posts when the page loads
    Future.microtask(() {
      Provider.of<SavedPostServices>(context, listen: false)
          .fetchSavedPosts()
          .then((_) {
        _initializeVideoControllers();
      });
    });

    // Initialize like counts
    _initializeLikeCounts();
  }

  void _initializeVideoControllers() {
    final savedPostService =
        Provider.of<SavedPostServices>(context, listen: false);
    for (var post in savedPostService.savedPosts) {
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

  void _initializeLikeCounts() {
    // Initialize like counts from the feed service
    Future.delayed(Duration.zero, () {
      final feedService = Provider.of<FeedServices>(context, listen: false);
      final savedPostService =
          Provider.of<SavedPostServices>(context, listen: false);

      if (savedPostService.savedPosts.isNotEmpty) {
        for (var post in savedPostService.savedPosts) {
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

  Future<void> _handleUnsavePost(Map<String, dynamic> post) async {
    final savedPostService =
        Provider.of<SavedPostServices>(context, listen: false);
    await savedPostService.toggleSavePost(post);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved Posts',
        centerTitle: true,
        showBackButton: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        enableShadow: true,
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
                // Main saved posts content
                Expanded(
                  child: Consumer<SavedPostServices>(
                    builder: (context, savedPostService, _) {
                      if (savedPostService.loading) {
                        return _buildLoadingShimmer(context);
                      }

                      if (savedPostService.savedPosts.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return _buildSavedPostsList(context, savedPostService);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info shimmer
                Padding(
                  padding: const EdgeInsets.all(12),
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
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                // Image shimmer
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.white,
                ),
                // Actions shimmer
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                // Description shimmer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.bookmark,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Saved Posts Yet',
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'When you save posts, they will appear here for easy access.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Iconsax.home),
            label: Text(
              'Go to Feed',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPostsList(
      BuildContext context, SavedPostServices savedPostService) {
    return RefreshIndicator(
      onRefresh: () => savedPostService.fetchSavedPosts(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: savedPostService.savedPosts.length +
            1, // +1 for the clear all button
        itemBuilder: (context, index) {
          // Add a "Clear All" button at the top
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Show confirmation dialog
                  final shouldClear = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Clear All Saved Posts?',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'This action cannot be undone.',
                        style: GoogleFonts.urbanist(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.urbanist(),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.urbanist(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldClear == true) {
                    await savedPostService.clearAllSavedPosts();
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(
                  'Clear All Saved Posts',
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }

          final postIndex = index - 1; // Adjust for the clear all button
          final post = savedPostService.savedPosts[postIndex];
          final postId = post['postId'] ?? '';
          final userEmail = post['userEmail'] ?? '';
          final isExpanded = _expandedPosts[postId] ?? false;
          final isLiked = _likedPosts[postId] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post header with user info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 18,
                          child: Icon(
                            Iconsax.user,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        userEmail,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Show post options
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Post Options',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ListTile(
                                    leading: const Icon(Icons.bookmark_remove),
                                    title: Text(
                                      'Remove from Saved',
                                      style: GoogleFonts.urbanist(),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _handleUnsavePost(post);
                                    },
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

                // Post image
                GestureDetector(
                  onDoubleTap: () => _handleDoubleTapLike(postId),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Post image
                      CachedNetworkImage(
                        imageUrl: post['image'] ?? '',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),

                      // Heart animation on double tap
                      if (isLiked)
                        AnimatedOpacity(
                          opacity: isLiked ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 100,
                          ),
                        ),
                    ],
                  ),
                ),

                // Post actions
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Like button
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: () => _handleLikePost(postId),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _likeCount[postId]?.toString() ?? '0',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Comment button
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          _showCommentsBottomSheet(context, postId, userEmail);
                        },
                      ),

                      const Spacer(),

                      // Unsave button
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark,
                          color: Colors.teal,
                        ),
                        onPressed: () => _handleUnsavePost(post),
                      ),
                    ],
                  ),
                ),

                // Post description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['description'] ?? '',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                      ),
                      if ((post['description'] ?? '').length > 100 &&
                          !isExpanded)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _expandedPosts[postId] = true;
                            });
                          },
                          child: Text(
                            'Read more',
                            style: GoogleFonts.urbanist(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Post timestamp
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text(
                    'Saved on ${_formatDate(post['savedAt'] ?? DateTime.now())}',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
