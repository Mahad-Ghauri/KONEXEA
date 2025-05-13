// A widget that creates a pulsating effect
import 'package:flutter/material.dart';

class PulsatingWidget extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Duration pulseDuration;

  const PulsatingWidget({
    super.key,
    required this.child,
    this.enabled = false,
    this.pulseDuration = const Duration(seconds: 2),
  });

  @override
  State<PulsatingWidget> createState() => _PulsatingWidgetState();
}

class _PulsatingWidgetState extends State<PulsatingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(PulsatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
