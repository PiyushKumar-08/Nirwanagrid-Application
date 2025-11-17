import 'dart:ui';
import 'package:flutter/material.dart';
import 'appearance_screen.dart'; // Navigate to the new screen
// Make sure you have a route for '/profile' or change the navigation method
// import 'profile_screen.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final int _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss(BuildContext context) async {
    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on the current theme
    final Color scrimColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withOpacity(0.3)
        : Colors.grey.withOpacity(0.1);

    return GestureDetector(
      onTap: () => _dismiss(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: scrimColor, // Use the theme-aware color here
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // Prevent tap-through
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < _itemCount; i++)
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final intervalStart = i * 0.15;
                            final intervalEnd = intervalStart + 0.6;
                            final curved = CurvedAnimation(
                              parent: _controller,
                              curve: Interval(intervalStart, intervalEnd.clamp(0.0, 1.0),
                                  curve: Curves.easeOutBack),
                              reverseCurve: Interval(intervalStart, intervalEnd.clamp(0.0, 1.0),
                                  curve: Curves.easeInBack),
                            );
                            return FadeTransition(
                              opacity: curved,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.2, 0),
                                  end: Offset.zero,
                                ).animate(curved),
                                child: child,
                              ),
                            );
                          },
                          child: _buildPillOptionForItem(i),
                        ),
                      const SizedBox(height: 40),
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.7, 1, curve: Curves.easeIn),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png', // Ensure you have this asset
                            height: 50,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillOptionForItem(int index) {
    String label;
    bool isLogout = false;
    VoidCallback onTap;

    switch (index) {
      case 0:
        label = 'Profile';
        onTap = () {
          // Assumes you have a named route '/profile'
          _dismiss(context)
              .then((_) => Navigator.pushNamed(context, '/profile'));
        };
        break;
      case 1:
        label = 'Theme';
        onTap = () {
          // Navigate to the dedicated AppearanceScreen
          _dismiss(context).then((_) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AppearanceScreen())));
        };
        break;
      case 2:
        label = 'Smart Home Access';
        onTap = () {
          // TODO: Implement Smart Home Access logic
        };
        break;
      case 3:
        label = 'How to use';
        onTap = () {
          // TODO: Implement 'How to use' screen
        };
        break;
      case 4:
        label = 'Logout';
        isLogout = true;
        onTap = () {
          // Assumes your root route is '/'
          _dismiss(context).then((_) => Navigator.pushNamedAndRemoveUntil(
              context, '/', (route) => false));
        };
        break;
      default:
        return const SizedBox.shrink();
    }

    return _buildPillOption(
      context: context,
      label: label,
      onTap: onTap,
      isLogout: isLogout,
    );
  }

  Widget _buildPillOption({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    // Define colors based on the current theme
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color pillColor = isDarkMode
        ? Colors.white.withOpacity(0.15)
        : Colors.grey.shade200; // Solid light grey for light mode
        
    final Color borderColor = isDarkMode
        ? Colors.white.withOpacity(0.4)
        : Colors.grey.shade400; // Darker border for light mode

    final Color textColor = isLogout
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: pillColor, // Use theme-aware color
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: borderColor, // Use theme-aware color
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor, // Use theme-aware color
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

