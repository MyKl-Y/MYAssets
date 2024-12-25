// client/lib/screens/account_screen.dart

/*
UI Screen: Account Screen
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/token_manager.dart';
import '../utils/data_provider.dart';

import '../services/api_service.dart';

import 'login_screen.dart';

void _logout(BuildContext context) async {
  await TokenManager.deleteToken();

  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), 
      (route) => false,
    );
  }
}

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ApiService apiService = ApiService();
  //Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    //fetchUser();
    Future.microtask(() => context.read<DataProvider>().fetchUser());
  }

  /* void fetchUser() async {
    try {
      final data = await apiService.getUser();
      setState(() => user = data);
    } catch (e) {
      print('Error: $e');
    }
  } */

  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().user;

    return Scaffold(
      //appBar: AppBar(title: Text('Account')),
      body: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 2, 
                      color: Theme.of(context).colorScheme.surface
                    ),
                  ),
                  child: Icon(
                    Icons.mood,
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user['username']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                    ),
                    Text(
                      "${user['email']}",
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: MediaQuery.of(context).size.width < 769 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox( 
                        width: MediaQuery.of(context).size.width,
                        child: Text('Test')
                      ),
                    ),
                    ElevatedButton(onPressed: () { _logout(context); }, child: Text('Log out')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
