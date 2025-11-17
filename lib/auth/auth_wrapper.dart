import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

/// A widget that determines the initial screen based on the user's
/// authentication state.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // As soon as this widget is built, check the auth status.
    _checkAuthState();
  }

  /// Fetches the current authentication session from Amplify.
  ///
  /// Navigates to the appropriate screen based on whether the user is signed in.
  /// Using `pushReplacementNamed` ensures the user cannot press "back" to
  /// return to this loading screen.
  Future<void> _checkAuthState() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (mounted) { // Ensure the widget is still in the tree
        if (session.isSignedIn) {
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } on AuthException catch (e) {
      safePrint('AuthException in AuthWrapper: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking the authentication status.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
