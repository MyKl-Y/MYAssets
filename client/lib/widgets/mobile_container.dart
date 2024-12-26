// client/lib/widgets/mobile_container.dart

/*
Container Widget for placement of navigation bar and content for mobile
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/account_screen.dart';

import '../utils/nav_state_manager.dart';

class MobileContainer extends StatelessWidget {
  const MobileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final navigationState = Provider.of<NavigationState>(context);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: true,
        child: <Widget>[
          HomeScreen(),
          DashboardScreen(),
          AddScreen(),
          TransactionsScreen(),
          AccountScreen(),
        ][navigationState.currentPageIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        shape: CircleBorder(),
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          AddScreen.showAddDialog(context, navigationState);
          navigationState.setPageIndex(0);
        },
        child: Icon(Icons.add_circle, color: theme.colorScheme.surface),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent
        ),
        child:  BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          color: theme.colorScheme.inversePrimary,
          elevation: 0,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationState.currentPageIndex,
            iconSize: 20,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: theme.colorScheme.primary,
            onTap: (int index) {
              navigationState.setPageIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home, color: theme.colorScheme.surface),
                icon: Icon(Icons.home_outlined), 
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.dashboard, color: theme.colorScheme.surface),
                icon: Icon(Icons.dashboard_outlined), 
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.add_circle, color: theme.colorScheme.surface),
                icon: Icon(Icons.add_circle_outline), 
                label: 'Add',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.paid, color: theme.colorScheme.surface),
                icon: Icon(Icons.paid_outlined), 
                label: 'Transaction',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.account_circle, color: theme.colorScheme.surface),
                icon: Icon(Icons.account_circle_outlined), 
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}