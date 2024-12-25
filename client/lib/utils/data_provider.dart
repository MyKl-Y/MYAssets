// client/lib/utils/data_provider.dart

/*
Stores the fetched data in a shared state and refresh it only when needed.
*/

import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<dynamic> _accounts = [];
  List<String> _accountNames = [];
  bool _hasFetchedAccounts = false;
  List<dynamic> get accounts => _accounts;
  List<String> get accountNames => _accountNames;

  Future<void> fetchAccounts() async {
    if (_hasFetchedAccounts) return;
    try {
      final accounts = await _apiService.getAccounts();
      _accounts = accounts;
      _accountNames = accounts.map<String>((account) => account['name'] as String).toList();
      _hasFetchedAccounts = true;
      notifyListeners();
    } catch (e) {
      print("Error fetching accounts: $e");
    }
  }

  Future<void> refreshAccounts() async {
    try {
      final accounts = await _apiService.getAccounts();
      _accounts = accounts;
      _accountNames = accounts.map<String>((account) => account['name'] as String).toList();
      _hasFetchedAccounts = true;
      notifyListeners();
    } catch (e) {
      print("Error refreshing accounts: $e");
    }
  }

  Map<String, dynamic> _user = {};
  bool _hasFetchedUser = false;
  Map<String, dynamic> get user => _user;

  Future<void> fetchUser() async {
    if (_hasFetchedUser) return;
    try {
      final user = await _apiService.getUser();
      _user = user;
      _hasFetchedUser = true;
      notifyListeners();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = await _apiService.getUser();
      _user = user;
      _hasFetchedUser = true;
      notifyListeners();
    } catch (e) {
      print("Error refreshing user: $e");
    }
  }

  List<dynamic> _transactions = [];
  bool _hasFetchedTransactions = false;
  List<dynamic> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    if (_hasFetchedTransactions) return;
    try {
      final transactions = await _apiService.getTransactions();
      _transactions = transactions;
      _hasFetchedTransactions = true;
      notifyListeners();
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  Future<void> refreshTransactions() async {
    try {
      final transactions = await _apiService.getTransactions();
      _transactions = transactions;
      _hasFetchedTransactions = true;
      notifyListeners();
    } catch (e) {
      print("Error refreshing transactions: $e");
    }
  }
}
