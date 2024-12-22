// client/lib/main.dart

/*
Entry Point
*/

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:m_y_assets/widgets/mobile_container.dart';
import 'package:m_y_assets/widgets/desktop_container.dart';

import 'screens/login_screen.dart';
//import 'screens/home_screen.dart';

import 'utils/token_manager.dart';

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
  runApp(MYAssetsApp(isLoggedIn: token != null));
}

class MYAssetsApp extends StatelessWidget {
  final bool isLoggedIn;

  const MYAssetsApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          //theme: ThemeData(useMaterial3: true),
          home: isLoggedIn ? DesktopContainer() : LoginScreen(),
        );
    } else {
      if (Platform.isIOS || Platform.isAndroid) {
        return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          //theme: ThemeData(useMaterial3: true),
          home: isLoggedIn ? MobileContainer() : LoginScreen(),
        );
      } else {
        return MaterialApp(
          title: 'M.Y.Assets - Personal Finance App',
          //theme: ThemeData(useMaterial3: true),
          home: isLoggedIn ? DesktopContainer() : LoginScreen(),
        );
      }
    }
  }
}
