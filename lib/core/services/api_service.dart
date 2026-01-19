import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // CONFIGURATION:
  // For Web (Chrome), use 'http://localhost:5000/api'
  // For Android Emulator, use 'http://10.0.2.2:5000/api'
  // For Physical Device, use your PC's LAN IP (e.g. 'http://192.168.1.5:5000/api')
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else {
      return 'http://10.0.2.2:5000/api';
    }
  }

  // ==========================================
  // AUTHENTICATION
  // ==========================================

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': 'student',
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Registration failed');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ==========================================
  // RESEARCH
  // ==========================================

  // Get user's papers
  static Future<List<dynamic>> getMyResearch() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/research/my/papers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['papers'];
    } else {
      throw Exception('Failed to load papers');
    }
  }

  // Upload Research (Mobile - File Path)
  static Future<void> submitResearch({
    required String title,
    required String abstract,
    String? keywords,
    required String category,
    String? coAuthors,
    required String filePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/research/submit'));
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['abstract'] = abstract;
    request.fields['category'] = category;
    if (keywords != null && keywords.isNotEmpty) request.fields['keywords'] = keywords;
    if (coAuthors != null && coAuthors.isNotEmpty) request.fields['coAuthors'] = coAuthors;

    request.files.add(await http.MultipartFile.fromPath('file', filePath, contentType: MediaType('application', 'pdf')));

    var response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Upload failed: $respStr');
    }
  }

  // Upload Research (Web - Bytes)
  static Future<void> submitResearchFromBytes({
    required String title,
    required String abstract,
    String? keywords,
    required String category,
    String? coAuthors,
    required Uint8List bytes,
    required String filename,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/research/submit'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['abstract'] = abstract;
    request.fields['category'] = category;
    if (keywords != null && keywords.isNotEmpty) request.fields['keywords'] = keywords;
    if (coAuthors != null && coAuthors.isNotEmpty) request.fields['coAuthors'] = coAuthors;

    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename, contentType: MediaType('application', 'pdf')));

    var response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Upload failed: $respStr');
    }
  }

  // Get published/approved papers for browsing
  static Future<List<dynamic>> getPublishedPapers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/research/published'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['papers'] ?? [];
    } else {
      throw Exception('Failed to load published papers');
    }
  }
}