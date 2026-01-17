import 'package:flutter/material.dart';
// FIX 1: Point to the new location in features/auth
import 'features/auth/Landing.dart'; 
// FIX 2: Point to the new location in core/constants
import 'core/constants/app_theme.dart'; 

void main() {
  runApp(const ResearchHubApp());
}

class ResearchHubApp extends StatelessWidget {
  const ResearchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Landing(),
    );
  }
}