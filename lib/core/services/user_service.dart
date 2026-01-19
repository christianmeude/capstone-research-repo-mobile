import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart'; // Import to access baseUrl

class UserModel {
  final String name;
  final String program;
  final String id;
  final String? avatarUrl;

  UserModel({
    required this.name,
    required this.program,
    required this.id,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class UserService {
  static Future<UserModel?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        return UserModel(
          name: data['fullName'] ?? 'Unknown',
          program: data['program'] ?? 'BSIT-MWA', // Default if null
          id: data['id']?.toString() ?? '',
        );
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}