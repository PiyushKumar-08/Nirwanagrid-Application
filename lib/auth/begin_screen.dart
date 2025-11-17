import 'package:flutter/material.dart';
import '/auth/auth_service.dart'; // Import the service

class BeginScreen extends StatefulWidget {
  const BeginScreen({super.key});

  @override
  State<BeginScreen> createState() => _BeginScreenState();
}

class _BeginScreenState extends State<BeginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // --- Phone Sign In Logic ---
  void _sendOtp() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      _showError("Please enter a valid 10-digit phone number.");
      return;
    }

    setState(() => _isLoading = true);

    // IMPORTANT: Format number to E.164. Assuming Indian numbers.
    final phoneNumber = '+91${_phoneController.text.trim()}';

    await _authService.signInWithPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: () {
        setState(() => _isLoading = false);
        Navigator.pushNamed(context, '/otp');
      },
      onError: (message) {
        setState(() => _isLoading = false);
        _showError(message);
      },
    );
  }

  // --- Social Sign In Logic ---
  Future<void> _handleSocialSignIn(Future<void> Function() signInMethod) async {
    setState(() => _isLoading = true);
    await signInMethod();
    final isSignedIn = await _authService.isUserSignedIn();
    if (isSignedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Nirwanagrid',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Zero Effort, Peaceful Living',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Spacer(flex: 3),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter phone number',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)), borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)), borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  backgroundColor: const Color(0xFF2DBB54),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send OTP'),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTextButton('Create account', () { /* TODO: Navigate to Sign Up Screen */ }),
                      _buildDivider(),
                      _buildTextButton('Forgot password?', () { /* TODO: Navigate to Forgot Password Screen */ }),
                    ],
                  ),
                  _buildTextButton('Sign in via email', () { /* TODO: Navigate to Email Sign In Screen */ }),
                ],
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Other ways to sign in", style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider()),
                ]),
              ),
              const SizedBox(height: 32),
              // --- MODIFIED SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSocialButton('assets/images/google_logo.png', () => _handleSocialSignIn(_authService.signInWithGoogle)),
                  const SizedBox(width: 24),
                  _buildSocialButton('assets/images/facebook_logo.png', () => _handleSocialSignIn(_authService.signInWithFacebook)),
                  // The Guest login button has been removed from here.
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (No Changes Here) ---
  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return TextButton(onPressed: onPressed, child: Text(text, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)));
  }

  Widget _buildDivider() {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('|', style: TextStyle(color: Colors.grey, fontSize: 16)));
  }

  Widget _buildSocialButton(String imagePath, VoidCallback onPressed) {
    return GestureDetector(onTap: onPressed, child: CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300, child: CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath), backgroundColor: Colors.white)));
  }

  // This helper is no longer used but can be kept for future use or removed.
  Widget _buildSocialIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(onTap: onPressed, child: CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300, child: CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(icon, color: Colors.black, size: 28))));
  }
}