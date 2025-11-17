import 'package:flutter/material.dart';
import '/home/home_screen.dart';
import '/explore/explore_screen.dart';
import '/subscription/subscription.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Assuming these screens are also theme-aware
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ExploreScreen(),
    SubscriptionScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _showSettingsOverlay(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showSettingsOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Let the SettingsScreen handle its own background
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 1.0,
          child: SettingsScreen(), // Ensure SettingsScreen is also themed
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);

    return Scaffold(
      // THEME UPDATE: Use the theme's background color
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/explore.png')),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/security.png')),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/settings.png')),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        // THEME UPDATE: Use the theme's primary color for selected items
        selectedItemColor: theme.colorScheme.primary,
        // THEME UPDATE: Use the theme's color for unselected items
        unselectedItemColor: theme.unselectedWidgetColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        // THEME UPDATE: Use a theme-appropriate surface color for the bar's background
        backgroundColor: theme.colorScheme.surface,
        showUnselectedLabels: true,
      ),
    );
  }
}