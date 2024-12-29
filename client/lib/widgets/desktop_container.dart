// client/lib/widgets/desktop_container.dart

/*
Container Widget for placement of navigation bar and content for desktop
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late NavigationState navigationState;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final navigationState = Provider.of<NavigationState>(context);

    Widget getView(int index) {
      switch (index) {
        case 0:
          return HomeScreen();
        case 1:
          return DashboardScreen();
        case 2:
          return AddScreen();
        case 3:
          return TransactionsScreen();
        case 4: 
          return AccountScreen();
        default:
          return HomeScreen();
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1280) {
          // Smaller screens (Tablet)
          final ancestorScaffold = Scaffold.maybeOf(context);

          final hasDrawer = ancestorScaffold != null && ancestorScaffold.hasDrawer;

          return Scaffold(
            drawer: Container(
              width: 200,
              color: theme.colorScheme.surface,
              child: ListView(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 3), 
                          child: Image.asset(
                            'assets/images/m.y logo.png',
                            height: 25,
                          ),
                        ),
                        Text(
                          ' Assets',
                          style: GoogleFonts.audiowide(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home, 
                      color: navigationState.currentPageIndex == 0 ? theme.colorScheme.primary : null
                    ), 
                    title: Text('Home'),
                    onTap: () {
                      navigationState.setPageIndex(0);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dashboard, 
                      color: navigationState.currentPageIndex == 1 
                        ? theme.colorScheme.primary 
                        : null
                    ), 
                    title: Text('Dashboard'),
                    onTap: () {
                      navigationState.setPageIndex(1);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle, 
                      color: navigationState.currentPageIndex == 2 
                        ? theme.colorScheme.primary 
                        : null
                    ),  
                    title: Text('Add'),
                    onTap: () {
                      Navigator.of(context).pop();
                      AddScreen.showAddDialog(context, navigationState);
                      navigationState.setPageIndex(2);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.paid, 
                      color: navigationState.currentPageIndex == 3 
                        ? theme.colorScheme.primary 
                        : null
                    ),  
                    title: Text('Transactions'),
                    onTap: () {
                      navigationState.setPageIndex(3);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_circle, 
                      color: navigationState.currentPageIndex == 4 
                        ? theme.colorScheme.primary 
                        : null
                    ),  
                    title: Text('Account'),
                    onTap: () {
                      navigationState.setPageIndex(4);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              leading: hasDrawer 
                ? IconButton(
                    onPressed: hasDrawer ? () => ancestorScaffold.openDrawer() : null,
                    icon: Icon(Icons.menu, color: theme.colorScheme.primary,)
                  )
                : null,
                //title: Text('Menu'),
            ),
            body: getView(navigationState.currentPageIndex),
          );
        } else {
          // Large screens (Desktop)
          return Row(
            children: [
              SizedBox(
                width: 240,
                child: Scaffold(
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5), 
                          child: Image.asset(
                            'assets/images/m.y logo.png',
                            height: 35,
                          ),
                        ),
                        Text(
                          ' Assets',
                          style: GoogleFonts.audiowide(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: ListView(
                    children: [
                      ListTile(
                        selected: navigationState.currentPageIndex == 0,
                        selectedTileColor: theme.colorScheme.inversePrimary.withAlpha(150),
                        leading: Icon(
                          Icons.home, 
                          color: navigationState.currentPageIndex == 0 
                            ? theme.colorScheme.primary 
                            : null
                        ), 
                        title: Text('Home'),
                        onTap: () {
                          navigationState.setPageIndex(0);
                        },
                      ),
                      ListTile(
                        selected: navigationState.currentPageIndex == 1,
                        selectedTileColor: theme.colorScheme.inversePrimary.withAlpha(150),
                        leading: Icon(
                          Icons.dashboard, 
                          color: navigationState.currentPageIndex == 1 
                            ? theme.colorScheme.primary 
                            : null
                        ), 
                        title: Text('Dashboard'),
                        onTap: () {
                          navigationState.setPageIndex(1);
                        },
                      ),
                      ListTile(
                        selected: navigationState.currentPageIndex == 2,
                        selectedTileColor: theme.colorScheme.inversePrimary.withAlpha(150),
                        leading: Icon(
                          Icons.add_circle, 
                          color: navigationState.currentPageIndex == 2 
                            ? theme.colorScheme.primary 
                            : null
                        ),  
                        title: Text('Add'),
                        onTap: () {
                          AddScreen.showAddDialog(context, navigationState, shiftRight: 240.5);
                          navigationState.setPageIndex(2);
                        },
                      ),
                      ListTile(
                        selected: navigationState.currentPageIndex == 3,
                        selectedTileColor: theme.colorScheme.inversePrimary.withAlpha(150),
                        leading: Icon(
                          Icons.paid, 
                          color: navigationState.currentPageIndex == 3 
                            ? theme.colorScheme.primary 
                            : null
                        ),  
                        title: Text('Transactions'),
                        onTap: () {
                          navigationState.setPageIndex(3);
                        },
                      ),
                      ListTile(
                        selected: navigationState.currentPageIndex == 4,
                        selectedTileColor: theme.colorScheme.inversePrimary.withAlpha(150),
                        leading: Icon(
                          Icons.account_circle, 
                          color: navigationState.currentPageIndex == 4 
                            ? theme.colorScheme.primary 
                            : null
                        ),  
                        title: Text('Account'),
                        onTap: () {
                          navigationState.setPageIndex(4);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 0.5, color: Colors.black),
              Expanded(
                child: getView(navigationState.currentPageIndex),
              ),
            ],
          );
        }
      }
    );
  }
}