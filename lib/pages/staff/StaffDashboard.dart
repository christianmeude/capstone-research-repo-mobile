import 'package:flutter/material.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Dashboard"), backgroundColor: Colors.orange),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.manage_accounts, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            Text("Staff Controls Coming Soon", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}