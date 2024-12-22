// client/lib/widgets/web_and_desktop_container.dart

/*
Container Widget for placement of navigation bar and content for web and desktop
*/

import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/account_screen.dart';

class DesktopContainer extends StatefulWidget {
  const DesktopContainer({super.key});

  @override
  State<DesktopContainer> createState() => _DesktopContainerState();
}

class _DesktopContainerState extends State<DesktopContainer> with TickerProviderStateMixin {
  late TabController _tabController;

  @override 
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.home), 
              text: 'Home',
            ),
            Tab(
              icon: Icon(Icons.dashboard), 
              text: 'Dashboard',
            ),
            Tab(
              icon: Icon(Icons.add_circle), 
              text: 'Add',
            ),
            Tab(
              icon: Icon(Icons.paid), 
              text: 'Transactions',
            ),
            Tab(
              icon: Icon(Icons.account_circle), 
              text: 'Account',
            ),
          ],
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomeScreen(),
          DashboardScreen(),
          AddScreen(),
          TransactionsScreen(),
          AccountScreen()
        ]
      ),
    );
  }
}