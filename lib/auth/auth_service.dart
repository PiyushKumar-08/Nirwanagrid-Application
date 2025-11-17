import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Sign in with Phone Number (sends OTP)
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: phoneNumber, // E.164 format e.g., +919876543210
      );

      if (result.nextStep.signInStep == AuthSignInStep.confirmSignInWithSmsMfaCode) {
        onCodeSent();
      }
    } on AuthException catch (e) {
      onError(e.message);
    }
  }

  // Confirm OTP
  Future<bool> confirmSignInWithOTP(String otp) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: otp,
      );
      return result.isSignedIn;
    } on AuthException catch (e) {
      safePrint('Error confirming OTP: ${e.message}');
      return false;
    }
  }

  // Sign in with Google (uses Hosted UI)
  Future<void> signInWithGoogle() async {
    try {
      await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
    } on AuthException catch (e) {
      safePrint('Error signing in with Google: ${e.message}');
    }
  }

  // Sign in with Facebook (uses Hosted UI)
  Future<void> signInWithFacebook() async {
    try {
      await Amplify.Auth.signInWithWebUI(provider: AuthProvider.facebook);
    } on AuthException catch (e) {
      safePrint('Error signing in with Facebook: ${e.message}');
    }
  }

  // Check if a user is currently signed in
  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint('Error signing out: ${e.message}');
    }
  }
}