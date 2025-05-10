// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_swap/Views/Components/pulsating_widget.dart';
import 'dart:math' as math;

import 'package:social_swap/Views/Interface/Comments/comment_dialog.dart';

class FeedComponents {
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

  static Widget buildFloatingActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool hasBorder = false,
    Color borderColor = Colors.transparent,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 4,
              onPressed: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: hasBorder
                      ? Border.all(color: borderColor, width: 2)
                      : null,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      icon,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildEnhancedLoadingShimmer(BuildContext context) {
    // Varied heights for more natural look
    final heights = [220, 180, 240, 200, 260];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) {
        // Staggered animation delay based on index
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 150)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Shimmer.fromColors(
                  baseColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  highlightColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.1),
                  period: Duration(milliseconds: 1200 + (index * 100)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced header with more realistic proportions
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 80,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu dots
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Enhanced content with varied heights
                          Container(
                            width: double.infinity,
                            height: heights[index % heights.length].toDouble(),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Enhanced caption area
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                2,
                                (lineIndex) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    width: double.infinity - (lineIndex * 40),
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Enhanced action buttons with better spacing
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Like, comment buttons
                                Row(
                                  children: List.generate(
                                    2,
                                    (i) => Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 30,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Share button
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget buildEnhancedEmptyState(
      BuildContext context, AnimationController animationController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyStateAnimation(context, animationController),
          const SizedBox(height: 24),
          _buildEmptyStateText(context),
          const SizedBox(height: 32),
          _buildCreatePostButton(context),
        ],
      ),
    );
  }

  static Widget _buildEmptyStateAnimation(
      BuildContext context, AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          height: 150,
          width: 150,
          child: Transform.rotate(
            angle: animationController.value * 2 * math.pi,
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
                  transform:
                      GradientRotation(animationController.value * 2 * math.pi),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
    );
  }

  static Widget _buildEmptyStateText(BuildContext context) {
    return Column(
      children: [
        Text(
          'No posts yet',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.tertiary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Be the first to share something amazing with your community!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildCreatePostButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add navigation to create post page
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      icon: const Icon(Iconsax.add_circle),
      label: Text(
        'Create Post',
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static Widget buildInteractionButton({
    required BuildContext context,
    required IconData icon,
    String? label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: color ?? Theme.of(context).colorScheme.tertiary,
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color ?? Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    String? subtitle,
  }) {
    final Color itemColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.tertiary;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: itemColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: itemColor,
            size: 22,
          ),
        ),
        title: Text(
          label,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: itemColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: itemColor.withOpacity(0.7),
                ),
              )
            : null,
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: itemColor.withOpacity(0.5),
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
