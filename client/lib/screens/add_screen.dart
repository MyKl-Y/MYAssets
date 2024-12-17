// client/lib/screens/add_screen.dart

/*
UI Screen: Add Screen
*/

import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add')),
      body: Center(child: Text('Add'))
    );
  }
}
