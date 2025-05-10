import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

/// A customizable app bar with modern design and animations
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Widget? leading;
  final Widget? titleWidget;
  final bool implyLeading;
  final double height;
  final bool showBorder;
  final PreferredSizeWidget? bottom;
  final bool enableShadow;
  final bool enableBlur;
  final double blurStrength;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.actions,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.leading,
    this.titleWidget,
    this.implyLeading = true,
    this.height = kToolbarHeight,
    this.showBorder = false,
    this.bottom,
    this.enableShadow = false,
    this.enableBlur = false,
    this.blurStrength = 10,
    this.systemOverlayStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final fgColor = foregroundColor ?? theme.colorScheme.tertiary;

    Widget appBarContent = AppBar(
      title: titleWidget ?? Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: enableShadow ? elevation : 0,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: bgColor.computeLuminance() > 0.5 
            ? Brightness.dark 
            : Brightness.light,
        statusBarBrightness: bgColor.computeLuminance() > 0.5 
            ? Brightness.light 
            : Brightness.dark,
      ),
      leading: leading ?? (showBackButton && Navigator.canPop(context)
          ? _buildBackButton(context, fgColor)
          : null),
      automaticallyImplyLeading: implyLeading,
      actions: actions,
      bottom: bottom,
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            )
          : null,
    );

    if (enableShadow) {
      appBarContent = Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: appBarContent,
      );
    }

    if (enableBlur) {
      // Note: For a real blur effect, you would need to use a package like 'blur'
      // This is a simplified version
      appBarContent = ClipRect(
        child: Stack(
          children: [
            Container(
              color: bgColor.withOpacity(0.85),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurStrength,
                sigmaY: blurStrength,
              ),
              child: appBarContent,
            ),
          ],
        ),
      );
    }

    return appBarContent;
  }

  Widget _buildBackButton(BuildContext context, Color color) {
    return IconButton(
      icon: Icon(
        Iconsax.arrow_left_2,
        color: color,
      ),
      splashRadius: 24,
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

/// A sliver version of the CustomAppBar
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final Widget? leading;
  final Widget? titleWidget;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;
  final bool showBorder;
  final PreferredSizeWidget? bottom;
  final bool enableShadow;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomSliverAppBar({
    Key? key,
    this.title = '',
    this.actions,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.leading,
    this.titleWidget,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.showBorder = false,
    this.bottom,
    this.enableShadow = false,
    this.systemOverlayStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final fgColor = foregroundColor ?? theme.colorScheme.tertiary;

    return SliverAppBar(
      title: titleWidget ?? Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: enableShadow ? 4 : 0,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: bgColor.computeLuminance() > 0.5 
            ? Brightness.dark 
            : Brightness.light,
        statusBarBrightness: bgColor.computeLuminance() > 0.5 
            ? Brightness.light 
            : Brightness.dark,
      ),
      leading: leading ?? (showBackButton && Navigator.canPop(context)
          ? _buildBackButton(context, fgColor)
          : null),
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      bottom: bottom,
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            )
          : null,
      shadowColor: enableShadow ? Colors.black.withOpacity(0.1) : Colors.transparent,
    );
  }

  Widget _buildBackButton(BuildContext context, Color color) {
    return IconButton(
      icon: Icon(
        Iconsax.arrow_left_2,
        color: color,
      ),
      splashRadius: 24,
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }
}