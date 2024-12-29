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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Timestamp', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ), 
            textAlign: TextAlign.center,
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Amount', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ), 
            textAlign: TextAlign.center,
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Description', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ), 
            textAlign: TextAlign.center,
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Type', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ), 
            textAlign: TextAlign.center,
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Category', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ), 
            textAlign: TextAlign.center,
          )
        ),
      ]
    )];

    for (var (index, transaction) in transactions.indexed) {
      if (transaction['account'] == account) {
        transactionRows.add(TableRow(
          decoration: BoxDecoration(
            color: (index % 2) == 0 
              ? Theme.of(context).colorScheme.surface 
              : Theme.of(context).colorScheme.inversePrimary,
            borderRadius: index == transactions.length - 1 
              ? BorderRadius.vertical(bottom: Radius.circular(8))
              : null
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0), 
              child: Text(
                transaction['timestamp'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (index % 2) == 0 
                    ? Theme.of(context).colorScheme.onSurface 
                    : Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0), child: Text(
              (transaction['amount'] as double).toStringAsFixed(2), 
              style: TextStyle(
                color: transaction['type'] == 'Income' 
                  ? Colors.green
                  : Colors.red,
                fontWeight: FontWeight.bold
              ), textAlign: TextAlign.center,
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0), 
              child: Text(
                transaction['description'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (index % 2) == 0 
                    ? Theme.of(context).colorScheme.onSurface 
                    : Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0), 
              child: Text(
                transaction['type'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (index % 2) == 0 
                    ? Theme.of(context).colorScheme.onSurface 
                    : Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ),            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0), 
              child: Text(
                transaction['category'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (index % 2) == 0 
                    ? Theme.of(context).colorScheme.onSurface 
                    : Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ),
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
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("${account['name']}: ${account['description'] ?? ''} ${account['type']} Account"),
                        SizedBox(
                          height: transactionRows.length * 20,
                          child: ListView.builder(
                            itemCount: transactionRows.length,
                            itemBuilder: (context, index) {
                              final transaction = transactionRows[index];

                              if (transaction['account'] == account['name']) {
                                return Container( 
                                  decoration: BoxDecoration(
                                    color: (index % 2) == 0 
                                      ? Theme.of(context).colorScheme.inversePrimary 
                                      : null,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      spacing: 1,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            transaction['timestamp'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: (index % 2) == 0 
                                                ? Theme.of(context).colorScheme.onPrimary 
                                                : Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          indent: 3,
                                          endIndent: 3,
                                          thickness: 1,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "> ${transaction['amount']}",
                                            style: TextStyle(
                                              color: transaction['type'] == 'Income' 
                                                ? Colors.green
                                                : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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

                List<dynamic> transactionRows = createTransactions(account['name'], transactions);

                return Card(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("${account['name']}: ${account['description'] ?? ''} ${account['type']} Account | Balance: ${account['balance']}"),
                        Table(
                          border: TableBorder.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          children: createTable(account['name'], transactionRows),
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
