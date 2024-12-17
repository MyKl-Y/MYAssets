// client/lib/widgets/mobile_container.dart

/*
Container Widget for placement of navigation bar and content for mobile
*/

import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/account_screen.dart';

class MobileContainer extends StatefulWidget {
  const MobileContainer({super.key});

  @override
  State<MobileContainer> createState() => _MobileContainerState();
}

class _MobileContainerState extends State<MobileContainer> with TickerProviderStateMixin {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: <Widget>[
          HomeScreen(),
          DashboardScreen(),
          AddScreen(),
          TransactionsScreen(),
          AccountScreen(),
        ][currentPageIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        shape: CircleBorder(),
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          setState(() {
            currentPageIndex = 2;
          });
        },
        child: Icon(Icons.add_circle, color: theme.colorScheme.surface),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        color: theme.colorScheme.inversePrimary,
        elevation: 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPageIndex,
          iconSize: 20,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.colorScheme.primary,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
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
    );
  }
}