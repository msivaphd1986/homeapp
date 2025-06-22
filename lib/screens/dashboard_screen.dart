import 'package:flutter/material.dart';
import 'account_screen.dart'; // Add imports for other screens as you build

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedScreen;

  final Map<String, Widget> screenRoutes = {
    'Account Screen': const AccountScreen(),
    // Add more screens here as needed
  };

  void _navigateToScreen(String? screenName) {
    if (screenName != null && screenRoutes.containsKey(screenName)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screenRoutes[screenName]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          DropdownButton<String>(
            underline: const SizedBox(),
            dropdownColor: Colors.grey[900],
            icon: const Icon(Icons.menu, color: Colors.white),
            items: screenRoutes.keys.map((screen) {
              return DropdownMenuItem(
                value: screen,
                child: Text(screen, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedScreen = value);
              _navigateToScreen(value);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Dashboard!'),
      ),
    );
  }
}