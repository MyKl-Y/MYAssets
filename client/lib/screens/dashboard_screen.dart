// client/lib/screens/dashboard_screen.dart

/*
UI Screen: Dashboard Screen
*/

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insights')),
      body: Column(
        children: [
          Container(
            // Transaction History Line Graph
          ),
          Container(
            // Transaction Categories Bar Graph
          ),
        ],
      ),
    );
  }
}
