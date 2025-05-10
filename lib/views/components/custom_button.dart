import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// A customizable button with various styles and animations
class CustomButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final bool enableHapticFeedback;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final ButtonType buttonType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final bool enableShadow;
  final double elevation;
  final bool animateOnTap;

  const CustomButton({
    Key? key,
    this.text,
    this.icon,
    required this.onPressed,
    this.style,
    this.isLoading = false,
    this.enableHapticFeedback = true,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.buttonType = ButtonType.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.enableShadow = true,
    this.elevation = 2.0,
    this.animateOnTap = true,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.animateOnTap && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.animateOnTap && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.animateOnTap && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    // Default colors based on button type
    Color defaultBackgroundColor;
    Color defaultForegroundColor;
    
    switch (widget.buttonType) {
      case ButtonType.filled:
        defaultBackgroundColor = theme.colorScheme.primary;
        defaultForegroundColor = theme.colorScheme.onPrimary;
        break;
      case ButtonType.outlined:
        defaultBackgroundColor = Colors.transparent;
        defaultForegroundColor = theme.colorScheme.primary;
        break;
      case ButtonType.text:
        defaultBackgroundColor = Colors.transparent;
        defaultForegroundColor = theme.colorScheme.primary;
        break;
      case ButtonType.tonal:
        defaultBackgroundColor = theme.colorScheme.primary.withOpacity(0.1);
        defaultForegroundColor = theme.colorScheme.primary;
        break;
    }
    
    final backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
    final foregroundColor = widget.foregroundColor ?? defaultForegroundColor;
    
    // Create the button content
    Widget buttonContent = widget.child ?? _buildDefaultContent(foregroundColor);
    
    // Add loading indicator if needed
    if (widget.isLoading) {
      buttonContent = Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.0,
            child: buttonContent,
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
        ],
      );
    }
    
    // Create the base button
    Widget button;
    
    switch (widget.buttonType) {
      case ButtonType.filled:
        button = ElevatedButton(
          onPressed: widget.isLoading ? null : _handlePress,
          style: _getButtonStyle(backgroundColor, foregroundColor),
          child: buttonContent,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: widget.isLoading ? null : _handlePress,
          style: _getButtonStyle(backgroundColor, foregroundColor),
          child: buttonContent,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: widget.isLoading ? null : _handlePress,
          style: _getButtonStyle(backgroundColor, foregroundColor),
          child: buttonContent,
        );
        break;
      case ButtonType.tonal:
        button = ElevatedButton(
          onPressed: widget.isLoading ? null : _handlePress,
          style: _getButtonStyle(backgroundColor, foregroundColor),
          child: buttonContent,
        );
        break;
    }
    
    // Apply scale animation if enabled
    if (widget.animateOnTap) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: button,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: button,
      );
    }
  }
  
  Widget _buildDefaultContent(Color foregroundColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: foregroundColor,
            size: 20,
          ),
          if (widget.text != null) const SizedBox(width: 8),
        ],
        if (widget.text != null)
          Text(
            widget.text!,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
      ],
    );
  }
  
  ButtonStyle _getButtonStyle(Color backgroundColor, Color foregroundColor) {
    final baseStyle = widget.style ??
        (widget.buttonType == ButtonType.outlined
            ? OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: BorderSide(color: foregroundColor, width: 1.5),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                elevation: widget.enableShadow ? widget.elevation : 0,
                shadowColor: widget.enableShadow
                    ? backgroundColor.withOpacity(0.4)
                    : Colors.transparent,
              ));

    return baseStyle.copyWith(
      padding: MaterialStateProperty.all(widget.padding),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
  
  void _handlePress() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed();
  }
}

enum ButtonType {
  filled,
  outlined,
  text,
  tonal,
}