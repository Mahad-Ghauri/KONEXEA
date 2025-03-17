import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/views/Interface/feed_page.dart';
import 'package:social_swap/views/Interface/marketplace_page.dart';
import 'package:social_swap/views/Interface/news_page.dart';
import 'package:social_swap/views/Interface/profile_page.dart';
import 'package:social_swap/views/Interface/upload_page.dart';

class InterfacePage extends StatefulWidget {
  static const String id = 'InterfacePage';
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FeedPage(),
    const UploadPage(),
    const MarketplacePage(),
    const NewsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              color:
                  _selectedIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 1 ? Icons.add_box : Icons.add_box_outlined,
              color:
                  _selectedIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 2 ? Icons.store : Icons.store_outlined,
              color:
                  _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            label: 'Marketplace',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 3 ? Icons.newspaper : Icons.newspaper_outlined,
              color:
                  _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 4 ? Icons.person : Icons.person_outline,
              color:
                  _selectedIndex == 4
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
