// client/lib/services/api_service.dart

/*
API Service: Handles backend communication
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:42069/api/v1';

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

    return jsonDecode(response.body);
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
      await TokenManager.saveToken(data['access_token']);
      return true;
    }
    return false;
  }

  // Add Account
  Future<Map<String, dynamic>> addAccount(String name, String description, String accountType, double balance) async {
    final token = await TokenManager.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'type': accountType,
        'balance': balance
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add account');
    }
  }

  // Fetch Accounts
  Future<List<dynamic>> getAccounts() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // Add Transaction
  Future<Map<String, dynamic>> addTransaction(double amount, String description, String category, String account, String type, String date) async {
    final token = await TokenManager.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'description': description,
        'category': category,
        'account': account,
        'type': type,
        'timestamp': date
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add transaction');
    }
  }

  // Fetch Transactions
  Future<List<dynamic>> getTransactions() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}