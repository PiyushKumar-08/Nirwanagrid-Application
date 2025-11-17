 import 'package:flutter/material.dart';
import '/auth/auth_service.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _confirmOtp() async {
    if (_otpController.text.isEmpty || _otpController.text.length < 6) {
      _showError("Please enter a valid 6-digit OTP.");
      return;
    }
    setState(() => _isLoading = true);

    final isSignedIn = await _authService.confirmSignInWithOTP(_otpController.text.trim());

    if (isSignedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted) {
      setState(() => _isLoading = false);
      _showError("Invalid OTP. Please try again.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Confirmation Code")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "We've sent a 6-digit code to your phone number.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 16),
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _confirmOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}