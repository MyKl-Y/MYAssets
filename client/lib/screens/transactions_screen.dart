// client/lib/screens/transactions_screen.dart

/*
UI Screen: Transactions Screen
*/

import 'package:flutter/material.dart';
import 'package:m_y_assets/widgets/form_dropdown.dart';
import 'package:provider/provider.dart';

import '../widgets/account_form.dart';
import '../widgets/transaction_form.dart';

import '../services/api_service.dart';

import '../utils/nav_state_manager.dart';
import '../utils/data_provider.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiService apiService = ApiService();

  final NavigationState navigationState = NavigationState();

  List<dynamic> accounts = [];
  List<dynamic> transactions = [];
  
  List<Text> accountRows = [];

  @override
  void initState() {
    super.initState();
    //Future.microtask(() => context.read<DataProvider>().fetchAccounts());
    //Future.microtask(() => context.read<DataProvider>().fetchTransactions());
  }

  void _deleteAccount(int id) async {
    try {
      Map<String, dynamic> response = await apiService.deleteAccount(id);
      if (response['message'] == 'Account deleted') {
        context.read<DataProvider>().refreshAccounts();
      } else {
        throw Exception('Failed to delete account: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  void _updateAccount(int id, Map<String, dynamic> updates) async {
    try {
      Map<String, dynamic> response = await apiService.updateAccount(
        id,
        updates['name'],
        updates['description'],
        updates['type'],
        updates['balance'],
        updates['apy'],
      );

      if (response['message'] != 'Account not found' || response['message'] != 'Unauthorized') {
        context.read<DataProvider>().refreshAccounts();
      } else {
        throw Exception('Failed to update account: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to update account: $e');
    }
  }

  void _deleteTransaction(int id) async {
    try {
      Map<String, dynamic> response = await apiService.deleteTransaction(id);
      if (response['message'] == 'Transaction deleted') {
        context.read<DataProvider>().refreshTransactions();
        context.read<DataProvider>().refreshAccounts();
      } else {
        throw Exception('Failed to delete transaction: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  void _updateTransaction(int id, Map<String, dynamic> updates) async {
    try {
      Map<String, dynamic> response = await apiService.updateTransaction(
        id,
        updates['amount'],
        updates['description'],
        updates['category'],
        updates['account'],
        updates['type'],
        updates['date'],
      );

      if (response['message'] != 'Transaction not found' || response['message'] != 'Unauthorized') {
        context.read<DataProvider>().refreshTransactions();
      } else {
        throw Exception('Failed to update transaction: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  List<dynamic> createTransactions(String account, List<dynamic> transactions) {
    List<dynamic> transactionRows = [];

    for (var transaction in transactions) {
      if (transaction['account'] == account) {
        transactionRows.add(transaction);
      }
    }

    return transactionRows;
  }

  List<TableRow> createTable(String account, List<dynamic> transactions, double shiftRight) {
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0), 
          child: Text(
            'Edit', 
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
          key: ValueKey(transaction['id']),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    iconSize: 15,
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints.loose(Size(40, 40)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    onPressed: () => _deleteTransaction(transaction['id']), 
                    icon: Icon(Icons.close),
                  ),
                  IconButton.filled(
                    iconSize: 15,
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints.loose(Size(40, 40)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    onPressed: () { 
                      TextEditingController transactionAmountController = TextEditingController(text: transaction['amount'].toString());
                      TextEditingController transactionDescriptionController = TextEditingController(text: transaction['description']);
                      TextEditingController transactionAccountController = TextEditingController(text: transaction['account']);
                      TextEditingController transactionTypeController = TextEditingController(text: transaction['type']);
                      TextEditingController transactionCategoryController = TextEditingController(text: transaction['category']);
                      TextEditingController transactionTimestampController = TextEditingController(text: transaction['timestamp']);
                      GlobalKey<FormDropdownState> categoryDropdownKey = GlobalKey<FormDropdownState>();

                      TransactionForm.transactionForm(
                        'Update', 
                        context, 
                        navigationState,
                        shiftRight, 
                        transactionAmountController, 
                        transactionDescriptionController, 
                        transactionAccountController, 
                        transactionTypeController, 
                        transactionCategoryController, 
                        transactionTimestampController, 
                        categoryDropdownKey, 
                        _updateTransaction,
                        transaction['id'],
                        {
                          'amount': double.parse(transactionAmountController.text),
                          'description': transactionDescriptionController.text,
                          'account': transactionAccountController.text,
                          'type': transactionTypeController.text,
                          'category': transactionCategoryController.text,
                          'date': transactionTimestampController.text,
                        }
                      );
                    }, 
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ]
        ));
      }
    }

    return transactionRows;
  }

  @override
  Widget build(BuildContext context) {
    dynamic account;

    accounts = context.watch<DataProvider>().accounts;
    transactions = context.watch<DataProvider>().transactions;
    
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 769) {
            // Small screens (Mobile)
            return ListView.builder(
              key: ValueKey(accounts.length),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                account = accounts[index];

                List<dynamic> transactionRows = createTransactions(account['name'], transactions);

                return Card(
                  key: ValueKey(account['id']),
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${account['name']}: ${account['description'] ?? ''} ${account['type']} Account${account['type'] == 'Savings' ? ' | APY: ${account['apy']}%' : ''}"),
                            IconButton.filled(
                              iconSize: 15,
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints.loose(Size(40, 40)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.red),
                              ),
                              onPressed: () => _deleteAccount(account['id']), 
                              icon: Icon(Icons.close),
                            ),
                            IconButton.filled(
                              iconSize: 15,
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints.loose(Size(40, 40)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.blue),
                              ),
                              onPressed: () {
                                TextEditingController accountNameController = TextEditingController(text: account['name']);
                                TextEditingController accountDescriptionController = TextEditingController(text: account['description']);
                                TextEditingController accountTypeController = TextEditingController(text: account['type']);
                                TextEditingController accountBalanceController = TextEditingController(text: account['balance'].toString());
                                TextEditingController accountAPYController = TextEditingController(text: account['apy'].toString());

                                AccountForm.accountForm(
                                  'Update', 
                                  context, 
                                  navigationState,
                                  0, 
                                  accountNameController, 
                                  accountDescriptionController, 
                                  accountTypeController, 
                                  accountBalanceController, 
                                  accountAPYController, 
                                  _updateAccount,
                                  account['id'],
                                  {
                                    'name': accountNameController.text,
                                    'description': accountDescriptionController.text,
                                    'type': accountTypeController.text,
                                    'balance': double.parse(accountBalanceController.text),
                                    'apy': double.parse(accountAPYController.text),
                                  }
                                );
                              }, 
                              icon: Icon(Icons.edit),
                            ),
                          ]
                        ),     
                        SizedBox(
                          height: transactionRows.length * 20,
                          child: ListView.builder(
                            key: ValueKey(transactionRows.length),
                            itemCount: transactionRows.length,
                            itemBuilder: (context, index) {
                              final transaction = transactionRows[index];

                              if (transaction['account'] == account['name']) {
                                return Container( 
                                  key: ValueKey(transaction['id']),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton.filled(
                                                    iconSize: 15,
                                                    padding: EdgeInsets.all(2),
                                                    constraints: BoxConstraints.loose(Size(40, 40)),
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStateProperty.all(Colors.red),
                                                    ),
                                                    onPressed: () => _deleteTransaction(transaction['id']), 
                                                    icon: Icon(Icons.close),
                                                  ),
                                                  IconButton.filled(
                                                    iconSize: 15,
                                                    padding: EdgeInsets.all(2),
                                                    constraints: BoxConstraints.loose(Size(40, 40)),
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                                                    ),
                                                    onPressed: () { 
                                                      TextEditingController transactionAmountController = TextEditingController(text: transaction['amount'].toString());
                                                      TextEditingController transactionDescriptionController = TextEditingController(text: transaction['description']);
                                                      TextEditingController transactionAccountController = TextEditingController(text: transaction['account']);
                                                      TextEditingController transactionTypeController = TextEditingController(text: transaction['type']);
                                                      TextEditingController transactionCategoryController = TextEditingController(text: transaction['category']);
                                                      TextEditingController transactionTimestampController = TextEditingController(text: transaction['timestamp']);
                                                      GlobalKey<FormDropdownState> categoryDropdownKey = GlobalKey<FormDropdownState>();

                                                      TransactionForm.transactionForm(
                                                        'Update', 
                                                        context, 
                                                        navigationState,
                                                        0, 
                                                        transactionAmountController, 
                                                        transactionDescriptionController, 
                                                        transactionAccountController, 
                                                        transactionTypeController, 
                                                        transactionCategoryController, 
                                                        transactionTimestampController, 
                                                        categoryDropdownKey, 
                                                        _updateTransaction,
                                                        transaction['id'],
                                                        {
                                                          'amount': double.parse(transactionAmountController.text),
                                                          'description': transactionDescriptionController.text,
                                                          'account': transactionAccountController.text,
                                                          'type': transactionTypeController.text,
                                                          'category': transactionCategoryController.text,
                                                          'date': transactionTimestampController.text,
                                                        }
                                                      );
                                                    }, 
                                                    icon: Icon(Icons.edit),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                transaction['timestamp'].toString().split(' ')[0],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: (index % 2) == 0 
                                                    ? Theme.of(context).colorScheme.onPrimary 
                                                    : Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ],
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
            return LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  key: ValueKey(accounts.length),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];

                    List<dynamic> transactionRows = createTransactions(account['name'], transactions);

                    return Card(
                      key: ValueKey(account['id']),
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${account['name']}: ${account['description'] ?? ''} ${account['type']} Account | Balance: ${account['balance']}${account['type'] == 'Savings' ? ' | APY: ${account['apy']}%' : ''}"),
                                IconButton.filled(
                                  iconSize: 15,
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints.loose(Size(40, 40)),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () => _deleteAccount(account['id']), 
                                  icon: Icon(Icons.close),
                                ),
                                IconButton.filled(
                                  iconSize: 15,
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints.loose(Size(40, 40)),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                                  ),
                                  onPressed: () {
                                    TextEditingController accountNameController = TextEditingController(text: account['name']);
                                    TextEditingController accountDescriptionController = TextEditingController(text: account['description']);
                                    TextEditingController accountTypeController = TextEditingController(text: account['type']);
                                    TextEditingController accountBalanceController = TextEditingController(text: account['balance'].toString());
                                    TextEditingController accountAPYController = TextEditingController(text: account['apy'].toString());

                                    AccountForm.accountForm(
                                      'Update', 
                                      context, 
                                      navigationState,
                                      constraints.maxWidth > 769 ? 240.5 : 0, 
                                      accountNameController, 
                                      accountDescriptionController, 
                                      accountTypeController, 
                                      accountBalanceController, 
                                      accountAPYController, 
                                      _updateAccount,
                                      account['id'],
                                      {
                                        'name': accountNameController.text,
                                        'description': accountDescriptionController.text,
                                        'type': accountTypeController.text,
                                        'balance': double.parse(accountBalanceController.text),
                                        'apy': double.parse(accountAPYController.text),
                                      }
                                    );
                                  }, 
                                  icon: Icon(Icons.edit),
                                ),
                              ]
                            ),
                            Table(
                              border: TableBorder.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              children: createTable(account['name'], transactionRows, constraints.maxWidth > 769 ? 240.5 : 0),
                            ),
                          ]
                        )
                      )
                    );
                  },
                );
              }
            );
          }
        },
      )
    );
  }
}
