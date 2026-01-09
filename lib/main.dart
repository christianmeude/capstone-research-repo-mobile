import 'package:flutter/material.dart';
import 'pages/Landing.dart';
import 'theme/app_theme.dart';

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