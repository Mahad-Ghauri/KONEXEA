// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_swap/Views/Interface/profile/profile_page.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Interface/feed_page.dart';
import 'package:social_swap/views/Interface/news_page.dart';
import 'package:social_swap/views/Interface/upload_page.dart';

class InterfacePage extends StatefulWidget {
  static const String id = 'InterfacePage';
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage>
    with SingleTickerProviderStateMixin {
  final bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  late AnimationController _animationController;
  final Duration _transitionDuration = const Duration(milliseconds: 400);

  // Page transition animation
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  final List<Widget> _screens = [
    const FeedPage(),
    const UploadPage(),
    const NewsPage(),
    const ProfileScreen(),
  ];

  final AuthenticationController _authController = AuthenticationController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _transitionDuration,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_selectedIndex == index) return;

    _animationController.reset();
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedSwitcher(
        duration: _transitionDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _screens[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          buttonBackgroundColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          animationDuration: const Duration(milliseconds: 350),
          animationCurve: Curves.easeOutCubic,
          height: 60,
          items: [
            _buildNavItem(Iconsax.home, 0),
            _buildNavItem(Iconsax.add_circle, 1),
            _buildNavItem(Icons.public, 2),
            _buildNavItem(Iconsax.user, 3),
          ],
          index: _selectedIndex,
          onTap: _onTabChanged,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: isSelected ? 26 : 22,
          ),
        ],
      ),
    );
  }
}
