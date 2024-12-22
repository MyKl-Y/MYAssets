// client/lib/screens/login_screen.dart

/*
UI Screen: Login Screen
*/

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'register_screen.dart';

import '../services/api_service.dart';

import '../widgets/mobile_container.dart';
import '../widgets/desktop_container.dart';
import '../widgets/web_container.dart';
import '../widgets/form_input.dart';
import '../widgets/form.dart';

class LoginScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool hidePassword = true;

  void _login(BuildContext context) async {
    bool success = await apiService.loginUser(
      usernameController.text,
      passwordController.text,
    );
    
    if (context.mounted) {
      if (success) {
        if (kIsWeb) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WebContainer()));
        } else {
          if (Platform.isAndroid || Platform.isIOS) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MobileContainer()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DesktopContainer()));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(
              'Login failed', 
              style: TextStyle(fontWeight: FontWeight.bold)
            )),
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicForm([
      FormInput(
        type: 'username', 
        controller: usernameController, 
        hint: 'Username', 
        label: 'Username', 
        icon: Icons.person, 
        password: false, 
        keyboardType: TextInputType.text
      ),
      FormInput(
        type: 'password', 
        controller: passwordController, 
        hint: 'Password', 
        label: 'Password', 
        icon: Icons.key, 
        password: true, 
        keyboardType: TextInputType.visiblePassword
      ),
      //FormSubmitButton("Login", () => _login(context)),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: Text("Don't have an account? Register here"),
      ),
    ], 'Login', 'Login', () => _login(context));
  }
}
