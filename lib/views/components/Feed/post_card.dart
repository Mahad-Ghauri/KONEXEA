// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostCard extends StatefulWidget {
  final String imageUrl;
  final String description;
  final DateTime timestamp;
  final String postId;
  final String? videoUrl;
  final String? authorName;
  final String? authorAvatar;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onOptions;

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
    required this.postId,
    this.videoUrl,
    this.authorName,
    this.authorAvatar,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onOptions,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.videoUrl!);
      _videoController!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          _buildPostMedia(),
          _buildPostContent(),
          _buildPostActions(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: widget.authorAvatar != null
                ? CachedNetworkImageProvider(widget.authorAvatar!)
                : null,
            child:
                widget.authorAvatar == null ? const Icon(Iconsax.user) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.authorName ?? 'Anonymous',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Text(
                  formatDate(widget.timestamp),
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: widget.onOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildPostMedia() {
    if (widget.videoUrl != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VisibilityDetector(
              key: Key(widget.postId),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _videoController?.pause();
                }
              },
              child: _isVideoInitialized
                  ? VideoPlayer(_videoController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Iconsax.video,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
          child: const Center(
            child: Icon(Iconsax.image),
          ),
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        widget.description,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          height: 1.5,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            icon: widget.isLiked ? Iconsax.heart5 : Iconsax.heart,
            label: formatCount(widget.likesCount),
            onPressed: widget.onLike,
            color: widget.isLiked ? Colors.red : null,
          ),
          _buildActionButton(
            icon: Iconsax.message,
            label: formatCount(widget.commentsCount),
            onPressed: widget.onComment,
          ),
          _buildActionButton(
            icon: Iconsax.send_2,
            onPressed: widget.onShare,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? label,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? Theme.of(context).colorScheme.tertiary,
            ),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
