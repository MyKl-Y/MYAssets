// client/lib/screens/add_screen.dart

/*
UI Screen: Add Screen
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/form_dropdown.dart';
import '../widgets/account_form.dart';
import '../widgets/transaction_form.dart';

import '../services/api_service.dart';

import '../utils/data_provider.dart';
import '../utils/nav_state_manager.dart';

class AddScreen extends StatefulWidget {
  
  @override
  State<AddScreen> createState() => _AddScreenState();

  static void showAddDialog(BuildContext context, NavigationState navigationState, {double shiftRight = 0}) {
    bool exitedDialog = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: shiftRight),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Item',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    exitedDialog = false;
                    Navigator.pop(context); // Close the dialog
                    _AddScreenState()._showAddAccountForm(context, navigationState, shiftRight: shiftRight);
                  },
                  child: const Text('Add Account'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    exitedDialog = false;
                    Navigator.pop(context); // Close the dialog
                    _AddScreenState()._showAddTransactionForm(context, navigationState, shiftRight: shiftRight);
                  },
                  child: const Text('Add Transaction'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (exitedDialog) {
        navigationState.setPageIndex(3);
      }
    });
  }
}

class _AddScreenState extends State<AddScreen> {
  final ApiService apiService = ApiService();

  final GlobalKey<FormDropdownState> categoryDropdownKey = GlobalKey<FormDropdownState>();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountDescriptionController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController accountBalanceController = TextEditingController();
  final TextEditingController accountAPYController = TextEditingController();

  final TextEditingController transactionAmountController = TextEditingController();
  final TextEditingController transactionDescriptionController = TextEditingController();
  final TextEditingController transactionCategoryController = TextEditingController();
  final TextEditingController transactionAccountController = TextEditingController();
  final TextEditingController transactionTypeController = TextEditingController();
  final TextEditingController transactionTimestampController = TextEditingController();

  //List<String> accountNames = [];

  void _addAccount(BuildContext context) async {
    try {
      await apiService.addAccount(
        accountNameController.text,
        accountDescriptionController.text,
        accountTypeController.text,
        double.parse(accountBalanceController.text),
        double.parse(accountAPYController.text)
      );

      if (context.mounted) {
        await context.read<DataProvider>().refreshAccounts();
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(
              'Adding account failed: ${e.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        );
      }
    }
  }

  void _addTransaction(BuildContext context) async {
    try {
      DateTime transactionTimestamp = DateTime.parse(transactionTimestampController.text);
      String formattedTimestamp = transactionTimestamp.toIso8601String();

      await apiService.addTransaction(
        double.parse(transactionAmountController.text),
        transactionDescriptionController.text,
        transactionCategoryController.text,
        transactionAccountController.text,
        transactionTypeController.text,
        formattedTimestamp
      );

      if (context.mounted) {
        await context.read<DataProvider>().refreshTransactions();
        await context.read<DataProvider>().refreshAccounts();
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(
              'Adding transaction failed: ${e.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        );
      }
    }
  }

  void _showAddAccountForm(BuildContext context, NavigationState navigationState, {double shiftRight = 0}) {
    AccountForm.accountForm(
      'Add New',
      context,
      navigationState,
      shiftRight,
      accountNameController,
      accountDescriptionController,
      accountTypeController,
      accountBalanceController,
      accountAPYController,
      _addAccount,
      null,
      null
    );
  }

  void _showAddTransactionForm(BuildContext context, NavigationState navigationState, {double shiftRight = 0}) {
    TransactionForm.transactionForm(
      'Add New',
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
      _addTransaction,
      null,
      null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
