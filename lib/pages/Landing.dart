import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../auth/Login.dart';
import 'student/BrowseRepository.dart';
import '../theme/app_colors.dart'; // Add this import
import '../theme/app_text_styles.dart'; // Add this import

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String role = decodedToken['role'] ?? 'student';
      _navigateBasedOnRole(role);
    }
  }

  void _navigateBasedOnRole(String role) {
    if (!mounted) return;
    if (role == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BrowseRepository()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Role "$role" is not supported in this app.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary500.withOpacity(0.05),
              AppColors.background,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary500.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                size: 80,
                color: AppColors.primary500,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "ResearchHub",
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "NU Communities",
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Access your campus research anytime, anywhere.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text("Get Started", style: AppTextStyles.buttonLarge),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Optional: Add guest access if needed
              },
              child: Text(
                "Learn More",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
