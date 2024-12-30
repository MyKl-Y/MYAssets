// client/lib/widgets/account_form.dart

/*
Reusable Form for Adding/Updating Accounts
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './form.dart';
import './form_input.dart';
import './form_dropdown.dart';

import '../utils/nav_state_manager.dart';
import '../utils/data_provider.dart';

import '../services/api_service.dart';

class AccountForm {
  static void accountForm(
    String formName,
    BuildContext context, 
    NavigationState navigationState,
    double shiftRight, 
    TextEditingController accountNameController,
    TextEditingController accountDescriptionController,
    TextEditingController accountTypeController,
    TextEditingController accountBalanceController,
    TextEditingController accountAPYController,
    Function callback,
    int? id, 
    Map<String, dynamic>? updates
  ) {
    final ApiService apiService = ApiService();

    void updateAccount(int id, List<dynamic> updates) async {
      try {
        Map<String, dynamic> response = await apiService.updateAccount(
          id,
          updates[0],
          updates[1],
          updates[2],
          double.parse(updates[3]),
          double.parse(updates[4]),
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

    showDialog<void>(
      context: context,
      builder: (context) => Dialog( 
        insetPadding: EdgeInsets.only(left: shiftRight),
        child: BasicForm(
          childrenBeforeSubmit: [
            FormInput(
              type:'name', 
              controller: accountNameController, 
              hint: 'Savings', 
              label: 'Account Name', 
              icon: Icons.account_box, 
              password: false, 
              keyboardType: TextInputType.text,
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
            ),
            FormInput(
              type:'apy', 
              controller: accountAPYController, 
              hint: '0', 
              label: 'Account APY', 
              icon: Icons.percent, 
              password: false, 
              keyboardType: TextInputType.number
            ),
          ], 
          formName: '$formName Account', 
          submitButtonText: formName.split(' ')[0], 
          submitButtonCallback: () { 
            if (id != null) {
              updateAccount(id, [accountNameController.text, accountDescriptionController.text, accountTypeController.text, accountBalanceController.text, accountAPYController.text]);
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
