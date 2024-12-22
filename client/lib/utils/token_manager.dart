// client/lib/utils/token_manager.dart

/*
Utility: Token Manager
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TokenManager {
  static final _storage = FlutterSecureStorage();

  static const String baseUrl = 'http://127.0.0.1:42069/api/v1';

  static Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  static Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return null; // No refresh token available
    }

    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Authorization': 'Bearer $refreshToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access_token'];
      await _storage.write(key: 'access_token', value: newAccessToken);
      return newAccessToken;
    } else {
      await deleteToken(); // Refresh token is invalid; clear storage
      return null;
    }
  }
}