// client/lib/widgets/desktop_container.dart

/*
Container Widget for placement of navigation bar and content for desktop
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/account_screen.dart';

import '../utils/nav_state_manager.dart';

class DesktopContainer extends StatefulWidget {
  const DesktopContainer({super.key});

  @override
  State<DesktopContainer> createState() => _DesktopContainerState();
}

class _DesktopContainerState extends State<DesktopContainer> with TickerProviderStateMixin {
  late TabController _tabController;
  late NavigationState navigationState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationState = Provider.of<NavigationState>(context);

    // Initialize TabController with the shared navigation state
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: navigationState.currentPageIndex,
    );

    // Update NavigationState when the tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != navigationState.currentPageIndex) {
        if (_tabController.index == 2) {
          // Show the dialog when "Add" tab is selected
          AddScreen.showAddDialog(context);
          navigationState.setPageIndex(0); // Reset to the "Home" tab after dialog
          _tabController.animateTo(0); // Animate back to "Home" tab
          navigationState.setPageIndex(_tabController.index);
        } else if (_tabController.indexIsChanging || _tabController.index != navigationState.currentPageIndex) {
          navigationState.setPageIndex(_tabController.index);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final navigationState = Provider.of<NavigationState>(context);

    // Update TabController index if NavigationState changes externally
    if (_tabController.index != navigationState.currentPageIndex) {
      _tabController.animateTo(navigationState.currentPageIndex);
    }

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