// client/lib/screens/add_screen.dart

/*
UI Screen: Add Screen
*/

import 'package:flutter/material.dart';

import '../widgets/form_input.dart';
import '../widgets/form.dart';

import '../services/api_service.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final ApiService apiService = ApiService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  void _addAccount(BuildContext context) async {
    Map<String, dynamic> response = await apiService.addAccount(
      nameController.text,
      descriptionController.text,
      typeController.text,
      double.parse(balanceController.text)
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add')),
      body: BasicForm(
        [FormInput(
          type:'name', 
          controller: nameController, 
          hint: 'Savings', 
          label: 'Account Name', 
          icon: Icons.account_box, 
          password: false, 
          keyboardType: TextInputType.text
        ),
        FormInput(
          type:'description', 
          controller: descriptionController, 
          hint: 'Well\'s Fargo Bank', 
          label: 'Description', 
          icon: Icons.account_balance, 
          password: false, 
          keyboardType: TextInputType.text
        ),
        FormInput(
          type:'type', 
          controller: typeController, 
          hint: 'i.e. Savings, Checking', 
          label: 'Account Type', 
          icon: Icons.savings, 
          password: false, 
          keyboardType: TextInputType.text
        ),
        FormInput(
          type:'balance', 
          controller: balanceController, 
          hint: '0', 
          label: 'Account Balance', 
          icon: Icons.money, 
          password: false, 
          keyboardType: TextInputType.number
        ),
        ], 
        'Add New Account', 
        'Add', 
        () { _addAccount(context); }
      )
    );
  }
}
