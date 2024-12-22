// client/lib/screens/transactions_screen.dart

/*
UI Screen: Transactions Screen
*/

import 'package:flutter/material.dart';

import '../services/api_service.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> accounts = [];

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  void fetchAccounts() async {
    try {
      final data = await apiService.getAccounts();
      setState(() => accounts = data);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 769) {
            // Small screens (Mobile)
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  title: Text(account['description'] ?? 'No description'),
                  subtitle: Text('Balance: ${account['balance']}'),
                );
              },
            );
          } else {
            // Large screens (Desktop)
            return Container();
          }
        },
      )
      
    );
  }
}
