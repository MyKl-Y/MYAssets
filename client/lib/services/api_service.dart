// client/lib/services/api_service.dart

/*
API Service: Handles backend communication
*/

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/token_manager.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:42069/api/v1';

  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function(String accessToken) requestFunction,
  ) async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      throw Exception('No access token available');
    }

    // Attempt the request
    http.Response response = await requestFunction(accessToken);

    if (response.statusCode == 401) { // Token expired
      // Try refreshing the token
      accessToken = await TokenManager.refreshAccessToken();
      if (accessToken != null) {
        // Retry the request with the new token
        response = await requestFunction(accessToken);
      } else {
        throw Exception('Token refresh failed');
      }
    }

    return response;
  }

  // User Registration
  Future<Map<String, dynamic>> registerUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  // User Login
  Future<bool> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenManager.saveToken(data['access_token'], data['refresh_token']);
      return true;
    }
    return false;
  }

  // Add Account
  Future<Map<String, dynamic>> addAccount(String name, String description, String accountType, double balance) async {
    final response = await _authenticatedRequest((accessToken) {
      return http.post(
        Uri.parse('$baseUrl/accounts'),
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'type': accountType,
          'balance': balance
        }),
      );
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add account');
    }
  }

  // Fetch Accounts
  Future<List<dynamic>> getAccounts() async {
    final response = await _authenticatedRequest((accessToken) {
      return http.get(
        Uri.parse('$baseUrl/accounts'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // Add Transaction
  Future<Map<String, dynamic>> addTransaction(double amount, String description, String category, String account, String type, String date) async {
    final response = await _authenticatedRequest((accessToken) {
      return http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'description': description,
          'category': category,
          'account': account,
          'type': type,
          'timestamp': date
        }),
      );
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add transaction');
    }
  }

  // Fetch Transactions
  Future<List<dynamic>> getTransactions() async {
    final response = await _authenticatedRequest((accessToken) {
      return http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Fetch Transactions
  Future<dynamic> getUser() async {
    final response = await _authenticatedRequest((accessToken) {
      return http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}