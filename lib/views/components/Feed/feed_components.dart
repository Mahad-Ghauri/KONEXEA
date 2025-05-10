// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class FeedComponents {
  static Widget buildEnhancedLoadingShimmer(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1.0,
          curve: Curves.easeOut,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
            highlightColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
            period: Duration(milliseconds: 1000 + (index * 100)),
            child: _buildShimmerItem(index),
          ),
        );
      },
    );
  }

  static Widget _buildShimmerItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerHeader(),
            _buildShimmerContent(index),
            _buildShimmerFooter(),
          ],
        ),
      ),
    );
  }

  static Widget _buildShimmerHeader() {
    return Padding(
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
    );
  }

  static Widget _buildShimmerContent(int index) {
    return Container(
      width: double.infinity,
      height: 200 + (index * 20) % 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static Widget _buildShimmerFooter() {
    return Padding(
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
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
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

  static Widget buildInteractionButton({
    required BuildContext context,
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
              size: 20,
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

  static Widget buildOptionItem({
    required BuildContext context,
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
}
