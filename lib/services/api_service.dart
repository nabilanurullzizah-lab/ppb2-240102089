import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

/// Service terpisah untuk akses API (tidak dicampur dengan UI).
class ApiService {
  ApiService._();

  static const String _usersUrl = 'https://jsonplaceholder.typicode.com/users';

  static Future<List<User>> fetchUsers() async {
    final response = await http
        .get(Uri.parse(_usersUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
