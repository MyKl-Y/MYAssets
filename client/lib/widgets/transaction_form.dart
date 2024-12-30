// client/lib/widgets/transaction_form.dart

/*
Reusable Form for Adding/Updating Transactions
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './form.dart';
import './form_input.dart';
import './form_dropdown.dart';

import '../utils/nav_state_manager.dart';
import '../utils/data_provider.dart';

import '../services/api_service.dart';

class TransactionForm {

  static void transactionForm(
    String formName,
    BuildContext context,
    NavigationState navigationState,
    double shiftRight,
    TextEditingController transactionAmountController,
    TextEditingController transactionDescriptionController,
    TextEditingController transactionAccountController,
    TextEditingController transactionTypeController,
    TextEditingController transactionCategoryController,
    TextEditingController transactionTimestampController,
    GlobalKey<FormDropdownState> categoryDropdownKey,
    Function callback,
    int? id, 
    Map<String, dynamic>? updates
  ) {
    final ApiService apiService = ApiService();

    List<String> transactionCategoryItems = [
      'Other',
      'Salary', 'Gift', 'Interest',
    ];

    void updateCategories(String selectedType) {
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

    void updateTransaction(int id, List<dynamic> updates) async {
      try {
        Map<String, dynamic> response = await apiService.updateTransaction(
          id,
          double.parse(updates[0]),
          updates[1],
          updates[2],
          updates[3],
          updates[4],
          updates[5],
        );

        if (response['message'] != 'Transaction not found' || response['message'] != 'Unauthorized') {
          context.read<DataProvider>().refreshTransactions();
          context.read<DataProvider>().refreshAccounts();
        } else {
          throw Exception('Failed to update transaction: ${response['message']}');
        }
      } catch (e) {
        throw Exception('Failed to update transaction: $e');
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog( 
        insetPadding: EdgeInsets.only(left: shiftRight),
        child: BasicForm(
          childrenBeforeSubmit: [FormInput(
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
            items: context.watch<DataProvider>().accountNames,
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
                updateCategories(value); // Call the method to update categories
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
          formName: '$formName Transaction', 
          submitButtonText: formName.split(' ')[0], 
          submitButtonCallback: () { 
            if (id != null) {
              updateTransaction(id, [transactionAmountController.text, transactionDescriptionController.text, transactionCategoryController.text, transactionAccountController.text, transactionTypeController.text, transactionTimestampController.text]);
            } else {
              callback(context); 
            }
          }
        )
      )
    ).then((_) {
      //if (context.mounted) {
      //  Navigator.pop(context);
      //}
      navigationState.setPageIndex(3);
    });
  }
}