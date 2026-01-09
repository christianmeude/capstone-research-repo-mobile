import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), backgroundColor: Colors.redAccent),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 80, color: Colors.redAccent),
            SizedBox(height: 20),
            Text("Admin Controls Coming Soon", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}