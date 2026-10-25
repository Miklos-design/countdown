import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Events stay on this device for now. A home-screen widget can use the same countdown.',
          style: TextStyle(color: Color(0xFFA7B0C0), fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}
