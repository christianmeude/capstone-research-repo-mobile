import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../student/StudentDashboard.dart';
import 'Login.dart';
import 'Register.dart';

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
      // If token exists and is valid, go straight to dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary500.withOpacity(0.05), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Push content to bottom
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 200, // Placeholder for your illustration/logo
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.hub_rounded, size: 80, color: AppColors.primary500),
                  ),
                ),
                const Spacer(),
                Text(
                  "Welcome to",
                  style: AppTextStyles.heading3.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  "NUcleus",
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 42,
                    color: AppColors.primary600,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "The central hub for academic research and collaboration at National University.",
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight, height: 1.5),
                ),
                const SizedBox(height: 40),
                
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Login())),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text("Log In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary500, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("Create Student Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}