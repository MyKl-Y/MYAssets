// client/lib/screens/transactions_screen.dart

/*
UI Screen: Transactions Screen
*/

import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Center(child: Text('Transactions'))
    );
  }
}
