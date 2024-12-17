// client/lib/main.dart

/*
Entry Point
*/

import 'dart:developer';

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  if (kIsWeb) {
    print('Running on the web!');
    log('Running on the web!');
  } else if (Platform.isAndroid) {
    print('Running on Android!');
    log('Running on Android!');
  } else if (Platform.isIOS) {
    print('Running on iOS!');
    log('Running on iOS!');
  } else {
    print('Running on ${Platform.operatingSystem}!');
    log('Running on ${Platform.operatingSystem}!');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      theme: ThemeData(useMaterial3: true),
      home: LoginScreen(),
    );
  }
}
