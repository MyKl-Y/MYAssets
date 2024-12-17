// client/lib/screens/account_screen.dart

/*
UI Screen: Account Screen
*/

import 'package:flutter/material.dart';

import '../utils/token_manager.dart';

import 'login_screen.dart';

void _logout(BuildContext context) async {
  await TokenManager.deleteToken();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()), 
    (route) => false,
  );
}

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Center(
        child: 
          ElevatedButton(onPressed: () { _logout(context); }, child: Text('Log out'))
      )
    );
  }
}
