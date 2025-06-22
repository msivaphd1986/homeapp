import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isRememberMe = false;
  bool _isBiometricAvailable = false;

  static const String savedPinKey = 'savedPin';
  static const String rememberMeKey = 'rememberMe';

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _loadSavedPreferences();
  }

  Future<void> _checkBiometric() async {
    final available = await _auth.canCheckBiometrics;
    setState(() {
      _isBiometricAvailable = available;
    });
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(rememberMeKey) ?? false;
    final savedPin = prefs.getString(savedPinKey) ?? '';
    setState(() {
      _isRememberMe = saved;
      if (saved) _pinController.text = savedPin;
    });
  }

  Future<void> _login() async {
    final pin = _pinController.text.trim();
    if (pin.length != 4) {
      _showError("Please enter a 4-digit PIN");
      return;
    }

    if (_isRememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(rememberMeKey, true);
      await prefs.setString(savedPinKey, pin);
    }

    _navigateToDashboard();
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Use your fingerprint or face to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        _navigateToDashboard();
      }
    } catch (e) {
      _showError("Biometric auth failed: $e");
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter 4-digit PIN", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isRememberMe,
                  onChanged: (value) {
                    setState(() {
                      _isRememberMe = value ?? false;
                    });
                  },
                ),
                const Text("Remember me"),
              ],
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            if (_isBiometricAvailable)
              TextButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text("Use Biometric"),
                onPressed: _authenticateWithBiometrics,
              ),
          ],
        ),
      ),
    );
  }
}