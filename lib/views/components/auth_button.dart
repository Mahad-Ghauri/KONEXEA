// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final Color? customColor;
  final double? width;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.customColor,
    this.width,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor =
        widget.customColor ?? Theme.of(context).colorScheme.primary;
    final Color textColor =
        ThemeData.estimateBrightnessForColor(buttonColor) == Brightness.dark
            ? Colors.black
            : Colors.white;

    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: SizedBox(
          height: 60,
          width: widget.width ?? double.infinity,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isPressed = true;
              });
              _controller.forward();
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false;
              });
              _controller.reverse();
              widget.onPressed?.call();
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
              _controller.reverse();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color:
                //     HSLColor.fromColor(buttonColor)
                //         .withLightness(
                //           HSLColor.fromColor(buttonColor).lightness * 0.85,
                //         )
                //         .toColor(),
                color: Theme.of(context).colorScheme.primary,
                boxShadow:
                    _isPressed
                        ? []
                        : [
                          BoxShadow(
                            color: buttonColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: widget.isLoading ? null : widget.onPressed,
                  child: Center(
                    child:
                        widget.isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, color: textColor, size: 20),
                                  const SizedBox(width: 10),
                                ],
                                Text(
                                  widget.text,
                                  style: GoogleFonts.montaga(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
