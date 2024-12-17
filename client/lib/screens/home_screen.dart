// client/lib/screens/home_screen.dart

/*
UI Screen: Home Screen
*/

import 'package:flutter/material.dart';
//import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* final ApiService apiService = ApiService();
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      final data = await apiService.getTransactions();
      setState(() => transactions = data);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            title: Text(transaction['description'] ?? 'No description'),
            subtitle: Text('Amount: ${transaction['amount']}'),
          );
        },
      ),
    );
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home'))
    );
  }
}
