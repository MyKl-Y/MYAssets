// client/lib/screens/add_screen.dart

/*
UI Screen: Add Screen
*/

import 'package:flutter/material.dart';

import '../widgets/form_input.dart';
import '../widgets/form_dropdown.dart';
import '../widgets/form.dart';

import '../services/api_service.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();

  static void showAddDialog(BuildContext context, {double shiftRight = 0}) {
    _AddScreenState()._loadAccounts();

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
                    Navigator.pop(context); // Close the dialog
                    _AddScreenState()._showAddAccountForm(context, shiftRight: shiftRight);
                  },
                  child: const Text('Add Account'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _AddScreenState()._showAddTransactionForm(context, shiftRight: shiftRight);
                  },
                  child: const Text('Add Transaction'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddScreenState extends State<AddScreen> {
  final ApiService apiService = ApiService();

  final GlobalKey<FormDropdownState> categoryDropdownKey = GlobalKey<FormDropdownState>();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountDescriptionController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController accountBalanceController = TextEditingController();

  final TextEditingController transactionAmountController = TextEditingController();
  final TextEditingController transactionDescriptionController = TextEditingController();
  final TextEditingController transactionCategoryController = TextEditingController();
  final TextEditingController transactionAccountController = TextEditingController();
  final TextEditingController transactionTypeController = TextEditingController();
  final TextEditingController transactionTimestampController = TextEditingController();

  List<String> accountNames = [];
  List<String> transactionCategoryItems = [
    'Other',
    'Salary', 'Gift', 'Interest',
  ];
  
  @override 
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      List<dynamic> accounts = await apiService.getAccounts();
      //setState(() {
        accountNames = accounts.map<String>((account) => account['name'] as String).toList();
      //});
    } catch (e) {
      print("Error fetching accounts: $e");
      setState(() {
        accountNames = [];
      });
    }
  }

  void _updateCategories(String selectedType) {
    List<String> newCategories;
    if (selectedType == 'Income') {
      newCategories = ['Other', 'Salary', 'Gift', 'Interest',];
    } else if (selectedType == 'Expense') {
      newCategories = [
        'Other',
        'Housing',
        'Food',
        'Transportation',
        'Utilities',
        'Medical',
        'Education',
        'Childcare',
        'Subscriptions',
      ];
    } else {
      newCategories = [];
    }

    // Update the dropdown directly
    categoryDropdownKey.currentState?.resetItems(newCategories);
  }


  void _addAccount(BuildContext context) async {
    try {
      await apiService.addAccount(
        accountNameController.text,
        accountDescriptionController.text,
        accountTypeController.text,
        double.parse(accountBalanceController.text)
      );

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

  void _showAddAccountForm(BuildContext context, {double shiftRight = 0}) {
    initState();

    showDialog<void>(
      context: context,
      builder: (context) => Dialog( 
        insetPadding: EdgeInsets.only(left: shiftRight),
        child: BasicForm(
          [FormInput(
            type:'name', 
            controller: accountNameController, 
            hint: 'Savings', 
            label: 'Account Name', 
            icon: Icons.account_box, 
            password: false, 
            keyboardType: TextInputType.text
          ),
          FormInput(
            type:'description', 
            controller: accountDescriptionController, 
            hint: 'Well\'s Fargo Bank', 
            label: 'Account Description', 
            icon: Icons.account_balance, 
            password: false, 
            keyboardType: TextInputType.text
          ),
          FormDropdown(
            items: ['Savings', 'Checking'],
            controller: accountTypeController,
            hint: 'i.e. Savings, Checking',
            label: 'Account Type',
            icon: Icons.savings,
            hasDefaultValue: false,
          ),
          FormInput(
            type:'balance', 
            controller: accountBalanceController, 
            hint: '0', 
            label: 'Account Balance', 
            icon: Icons.money, 
            password: false, 
            keyboardType: TextInputType.number
          ),], 
          'Add New Account', 
          'Add', 
          () { _addAccount(context); }
        )
      )
    );
  }

  void _showAddTransactionForm(BuildContext context, {double shiftRight = 0}) {
    initState();

    showDialog(
      context: context,
      builder: (context) => Dialog( 
        insetPadding: EdgeInsets.only(left: shiftRight),
        child: BasicForm(
          [FormInput(
            type:'amount', 
            controller: transactionAmountController, 
            hint: '0.00', 
            label: 'Transaction Amount', 
            icon: Icons.money, 
            password: false, 
            keyboardType: TextInputType.number
          ),
          FormInput(
            type:'description', 
            controller: transactionDescriptionController, 
            hint: 'Amazon Subscription', 
            label: 'Transaction Description', 
            icon: Icons.description, 
            password: false, 
            keyboardType: TextInputType.text
          ),
          FormDropdown(
            controller: transactionAccountController, 
            hint: 'Savings', 
            label: 'Transaction Account', 
            icon: Icons.account_balance, 
            items: accountNames,
            hasDefaultValue: false,
          ),
          FormDropdown(
            controller: transactionTypeController, 
            hint: 'i.e., Income, Expense', 
            label: 'Transaction Type', 
            icon: Icons.attach_money, 
            items: ['Income', 'Expense'],
            hasDefaultValue: true,
            onChanged: (String? value) {
              if (value != null) {
                _updateCategories(value); // Call the method to update categories
              }
            },
          ),
          FormDropdown(
            key: categoryDropdownKey, // Force widget rebuild on list update
            controller: transactionCategoryController, 
            hint: 'e.g. Childcare, Subscription, etc.', 
            label: 'Transaction Category', 
            icon: Icons.category, 
            items: transactionCategoryItems,
            hasDefaultValue: true,
          ),
          FormInput(
            type:'timestamp', 
            controller: transactionTimestampController, 
            hint: 'Date', 
            label: 'Transaction Date', 
            icon: Icons.date_range, 
            password: false, 
            keyboardType: TextInputType.datetime
          ),], 
          'Add New Transaction', 
          'Add', 
          () { _addTransaction(context); }
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: 0,);
    /* Scaffold(
      appBar: AppBar(title: Text('Add')),
      body: Column( 
        children: [
          ElevatedButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => Dialog( 
                  child: BasicForm(
                    [FormInput(
                      type:'name', 
                      controller: accountNameController, 
                      hint: 'Savings', 
                      label: 'Account Name', 
                      icon: Icons.account_box, 
                      password: false, 
                      keyboardType: TextInputType.text
                    ),
                    FormInput(
                      type:'description', 
                      controller: accountDescriptionController, 
                      hint: 'Well\'s Fargo Bank', 
                      label: 'Account Description', 
                      icon: Icons.account_balance, 
                      password: false, 
                      keyboardType: TextInputType.text
                    ),
                    FormDropdown(
                      items: ['Savings', 'Checking'],
                      controller: accountTypeController,
                      hint: 'i.e. Savings, Checking',
                      label: 'Account Type',
                      icon: Icons.savings,
                      hasDefaultValue: false,
                    ),
                    FormInput(
                      type:'balance', 
                      controller: accountBalanceController, 
                      hint: '0', 
                      label: 'Account Balance', 
                      icon: Icons.money, 
                      password: false, 
                      keyboardType: TextInputType.number
                    ),], 
                    'Add New Account', 
                    'Add', 
                    () { _addAccount(context); }
                  )
                )
              );
            },
            child: const Text('Add New Account'),
          ),
          ElevatedButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => Dialog( 
                  child: BasicForm(
                    [FormInput(
                      type:'amount', 
                      controller: transactionAmountController, 
                      hint: '0.00', 
                      label: 'Transaction Amount', 
                      icon: Icons.money, 
                      password: false, 
                      keyboardType: TextInputType.number
                    ),
                    FormInput(
                      type:'description', 
                      controller: transactionDescriptionController, 
                      hint: 'Amazon Subscription', 
                      label: 'Transaction Description', 
                      icon: Icons.description, 
                      password: false, 
                      keyboardType: TextInputType.text
                    ),
                    FormDropdown(
                      controller: transactionAccountController, 
                      hint: 'Savings', 
                      label: 'Transaction Account', 
                      icon: Icons.account_balance, 
                      items: accountNames,
                      hasDefaultValue: false,
                    ),
                    FormDropdown(
                      controller: transactionTypeController, 
                      hint: 'i.e., Income, Expense', 
                      label: 'Transaction Type', 
                      icon: Icons.attach_money, 
                      items: ['Income', 'Expense'],
                      hasDefaultValue: true,
                      onChanged: (String? value) {
                        if (value != null) {
                          _updateCategories(value); // Call the method to update categories
                        }
                      },
                    ),
                    FormDropdown(
                      key: categoryDropdownKey, // Force widget rebuild on list update
                      controller: transactionCategoryController, 
                      hint: 'e.g. Childcare, Subscription, etc.', 
                      label: 'Transaction Category', 
                      icon: Icons.category, 
                      items: transactionCategoryItems,
                      hasDefaultValue: true,
                    ),
                    FormInput(
                      type:'timestamp', 
                      controller: transactionTimestampController, 
                      hint: 'Date', 
                      label: 'Transaction Date', 
                      icon: Icons.date_range, 
                      password: false, 
                      keyboardType: TextInputType.datetime
                    ),], 
                    'Add New Transaction', 
                    'Add', 
                    () { _addTransaction(context); }
                  )
                )
              );
            },
            child: const Text('Add New Transaction'),
          )
        ]
      )
    ); */
  }
}
