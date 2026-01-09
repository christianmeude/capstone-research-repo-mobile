import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/api_service.dart';
import '../pages/student/StudentDashboard.dart';
import '../pages/staff/StaffDashboard.dart';
import '../pages/admin/AdminDashboard.dart';
import '../theme/app_colors.dart'; // Add this import
import '../theme/app_text_styles.dart'; // Add this import

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final data = await ApiService.login(
        _emailController.text, 
        _passwordController.text
      );
      
      String token = data['token'];
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String role = decodedToken['role'] ?? 'student';

      if (!mounted) return;

      if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentDashboard()));
      } else if (role == 'staff') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StaffDashboard()));
      } else if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome Back",
          style: AppTextStyles.heading3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Sign in to ResearchHub",
                style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your credentials to access the research portal",
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              Text(
                "Email Address",
                style: AppTextStyles.labelMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "your.email@students.com",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Text(
                "Password",
                style: AppTextStyles.labelMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Add forgot password functionality
                  },
                  child: Text(
                    "Forgot Password?",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary500),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: AppColors.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Sign In",
                          style: AppTextStyles.buttonLarge,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Add registration navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration not implemented yet')),
                      );
                    },
                    child: Text(
                      "Contact Admin",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}