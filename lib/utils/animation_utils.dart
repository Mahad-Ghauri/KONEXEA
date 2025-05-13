// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// A utility class for common animations used throughout the app
class AnimationUtils {
  /// Creates a staggered fade-in animation for list items
  static Widget staggeredFadeIn({
    required int index,
    required Widget child,
    Duration baseDuration = const Duration(milliseconds: 600),
    Duration staggerDuration = const Duration(milliseconds: 150),
    Offset beginOffset = const Offset(0, 20),
    Curve curve = Curves.easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(
        milliseconds: baseDuration.inMilliseconds + (index * staggerDuration.inMilliseconds),
      ),
      curve: curve,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(
            beginOffset.dx * (1 - value),
            beginOffset.dy * (1 - value),
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  /// Creates a scale animation with optional bounce effect
  static Widget scaleAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    double beginScale = 0.95,
    double endScale = 1.0,
    Curve curve = Curves.easeOutBack,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: beginScale, end: endScale),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }

  /// Creates a pulsating animation effect
  static Widget pulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    double minScale = 0.97,
    double maxScale = 1.03,
    Curve curve = Curves.easeInOut,
    bool repeat = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: minScale, end: maxScale),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      onEnd: repeat
          ? () {
              // This creates the continuous pulsing effect
              minScale = minScale == 0.97 ? 1.03 : 0.97;
              maxScale = maxScale == 1.03 ? 0.97 : 1.03;
            }
          : null,
    );
  }

  /// Creates a shimmer loading effect container
  static Widget shimmerContainer({
    required BuildContext context,
    double? width,
    double? height,
    double borderRadius = 8,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
        shape: shape,
      ),
    );
  }

  /// Creates a page transition animation
  static Widget pageTransition({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0.05, 0),
    Offset endOffset = Offset.zero,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: beginOpacity, end: endOpacity).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }

  /// Creates a hero-like transition without using actual Hero widget
  static Widget customHeroTransition({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOutQuad,
  }) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
        child: child,
      ),
    );
  }
}

/// A route that provides custom page transitions
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset beginOffset;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.page,
    this.beginOffset = const Offset(0.05, 0),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}