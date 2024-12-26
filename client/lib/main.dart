// client/lib/main.dart

/*
Entry Point
*/

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'widgets/mobile_container.dart';
import 'widgets/desktop_container.dart';
import 'widgets/web_container.dart';

import 'screens/login_screen.dart';

import 'utils/token_manager.dart';
import 'utils/nav_state_manager.dart';
import 'utils/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await TokenManager.getAccessToken();

  if (kIsWeb) {
    print('Running on Web!');
    log('Running on Web!');
  } else {
    if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      print('Running on ${Platform.operatingSystem}!');
      log('Running on ${Platform.operatingSystem}!');
    } else if (Platform.isAndroid) {
      print('Running on Android!');
      log('Running on Android!');
    } else if (Platform.isIOS) {
      print('Running on iOS!');
      log('Running on iOS!');
    } 
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider()..fetchAccounts()..fetchTransactions()..fetchUser(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationState(),
        ),
      ],
      child: MYAssetsApp(isLoggedIn: token != null),
    ),
  );
}

class MYAssetsApp extends StatefulWidget {
  final bool isLoggedIn;

  const MYAssetsApp({required this.isLoggedIn, super.key});

  @override
  _MYAssetsAppState createState() => _MYAssetsAppState();

  static _MYAssetsAppState of(BuildContext context) =>
    context.findAncestorStateOfType<_MYAssetsAppState>()!;
}

class _MYAssetsAppState extends State<MYAssetsApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData.dark(),
          themeMode: _themeMode,
          home: widget.isLoggedIn ? WebContainer() : LoginScreen(),
        );
    } else {
      if (Platform.isIOS || Platform.isAndroid) {
        return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData.dark(),
          themeMode: _themeMode,
          home: widget.isLoggedIn ? MobileContainer() : LoginScreen(),
        );
      } else {
        return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData.dark(),
          themeMode: _themeMode,
          home: widget.isLoggedIn ? DesktopContainer() : LoginScreen(),
        );
      }
    }
  }
}
