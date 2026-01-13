import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // USE 10.0.2.2 for Android Emulator. Use LAN IP (e.g., 192.168.x.x) for physical phone.
  static const String baseUrl = 'http://localhost:5000/api';

  // NOTE: If running on Android emulator use 10.0.2.2:5000 instead of localhost.
  // Update this constant if you run the backend on a different host.

  // --- AUTHENTICATION ---
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save token for later
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  // --- RESEARCH ---

  // Get user's papers (Matches exports.getMyResearch)
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

  // Upload Research (Matches exports.submitResearch)
  static Future<void> submitResearch({
    required String title,
    required String abstract,
    String? keywords, // Comma separated string (optional)
    required String category,
    String? coAuthors,
    required String filePath, // Path from file_picker
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/research/submit'));
    
    // Headers
    request.headers['Authorization'] = 'Bearer $token';

    // Text Fields (Matches req.body in controller)
    request.fields['title'] = title;
    request.fields['abstract'] = abstract;
    request.fields['category'] = category;
    if (keywords != null && keywords.isNotEmpty) request.fields['keywords'] = keywords;
    if (coAuthors != null && coAuthors.isNotEmpty) request.fields['coAuthors'] = coAuthors;

    // File (Matches upload.single('file'))
    request.files.add(await http.MultipartFile.fromPath('file', filePath, contentType: MediaType('application', 'pdf')));

    var response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Upload failed: $respStr');
    }
  }

  // Upload using raw bytes (used on web where file paths are unavailable)
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