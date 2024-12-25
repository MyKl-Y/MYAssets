// client/lib/screens/transactions_screen.dart

/*
UI Screen: Transactions Screen
*/

import 'package:flutter/material.dart';
import 'package:m_y_assets/utils/data_provider.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiService apiService = ApiService();
  //List<dynamic> accounts = [];
  //List<dynamic> transactions = [];
  List<Text> accountRows = [];

  @override
  void initState() {
    super.initState();
    // fetchAccounts();
    // fetchTransactions();
    Future.microtask(() => context.read<DataProvider>().fetchAccounts());
    Future.microtask(() => context.read<DataProvider>().fetchTransactions());
  }

  void createAccounts(List<dynamic> accounts) {
    for (var account in accounts) {
      accountRows.add(Text("${account['description'] ?? ''} ${account['type']} Account | Balance: ${account['balance']}"));
    }
  }

  /* void fetchAccounts() async {
    try {
      final data = await apiService.getAccounts();
      setState(() => accounts = data);
    } catch (e) {
      print('Error: $e');
    }
  } */

  List<dynamic> createTransactions(String account, List<dynamic> transactions) {
    List<dynamic> transactionRows = [];

    for (var transaction in transactions) {
      if (transaction['account'] == account) {
        transactionRows.add(transaction);
      }
    }

    return transactionRows;
  }

  List<TableRow> createTable(String account, List<dynamic> transactions) {
    List<TableRow> transactionRows = [TableRow(
      decoration: BoxDecoration(color: Colors.grey),
      children: [
        Text('Timestamp', style: TextStyle(color: Colors.white)),
        Text('Amount', style: TextStyle(color: Colors.white)),
        Text('Description', style: TextStyle(color: Colors.white)),
        Text('Type', style: TextStyle(color: Colors.white)),
        Text('Category', style: TextStyle(color: Colors.white)),
      ]
    )];

    for (var transaction in transactions) {
      if (transaction['account'] == account) {
        transactionRows.add(TableRow(
          decoration: BoxDecoration(
            color: transaction['type'] == 'Income' ? Colors.lightGreen : Colors.red
          ),
          children: [
            Text(transaction['timestamp']),
            Text('${transaction['amount']}'),
            Text(transaction['description']),
            Text(transaction['type']),
            Text(transaction['category'])
          ]
        ));
      }
    }

    return transactionRows;
  }

  /* void fetchTransactions() async {
    try {
      final data = await apiService.getTransactions();
      setState(() => transactions = data);
    } catch (e) {
      print('Error: $e');
    }
  } */

  @override
  Widget build(BuildContext context) {
    dynamic account;

    final accounts = context.watch<DataProvider>().accounts;
    final transactions = context.watch<DataProvider>().transactions;
    
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 769) {
            // Small screens (Mobile)
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                account = accounts[index];

                List<dynamic> transactionRows = createTransactions(account['name'], transactions);

                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("${account['name']} ${account['description'] ?? ''} ${account['type']} Account"),
                        SizedBox(
                          height: transactionRows.length * 20,
                          child: ListView.builder(
                            itemCount: transactionRows.length,
                            itemBuilder: (context, index) {
                              final transaction = transactionRows[index];

                              if (transaction['account'] == account['name']) {
                                return Text(
                                  "> ${transaction['amount']}",
                                  style: TextStyle(
                                    color: transaction['type'] == 'Income' 
                                      ? Colors.green
                                      : Colors.red
                                  ),
                                );
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Text("Balance: ${account['balance']}")
                      ]
                    )
                  )
                );
              },
            );
          } else {
            // Large screens (Desktop)
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                account = accounts[index];

                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("${account['name']}: ${account['description'] ?? ''} ${account['type']} Account | Balance: ${account['balance']}"),
                        Table(
                          border: TableBorder.all(),
                          children: createTable(account['name'], transactions),
                        ),
                      ]
                    )
                  )
                );
              },
            );
          }
        },
      )
    );
  }
}
