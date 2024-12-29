// client/lib/screens/register_screen.dart

/*
UI Screen: Register Screen
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';

import '../widgets/form_input.dart';
import '../widgets/form.dart';

import '../utils/data_provider.dart';

class RegisterScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  

  void _register(BuildContext context) async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    //final String confirmPassword = confirmPasswordController.text;

    try {
      final response = await apiService.registerUser(username, email, password);
      if (!(response['message'].toString().contains('Username already exists')) && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Registration successful!')));
        if (context.mounted) {
          await context.watch<DataProvider>().refreshUser();
        }
        Navigator.pop(context); // Navigate back to login screen
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(
              'Registration failed: ${e.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: BasicForm(
            childrenBeforeSubmit: [
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
                type: 'email', 
                controller: emailController, 
                hint: 'Email@Email.com', 
                label: 'Email', 
                icon: Icons.email, 
                password: false, 
                keyboardType: TextInputType.emailAddress
              ),
              FormInput(
                type: 'password', 
                controller: passwordController, 
                hint: 'Password', 
                label: 'Password', 
                icon: Icons.key, 
                password: true, 
                keyboardType: TextInputType.visiblePassword,
                additionalValidator: (value) {
                  if (value != confirmPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              FormInput(
                type: 'password', 
                controller: confirmPasswordController, 
                hint: 'Password', 
                label: 'Confirm Password', 
                icon: Icons.check, 
                password: true, 
                keyboardType: TextInputType.visiblePassword,
                additionalValidator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
            childrenAfterSubmit: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Navigate back to Login
                child: Text('Already have an account? Login here'),
              ),
            ], 
            formName: 'Register', 
            submitButtonText: 'Register', 
            submitButtonCallback: () => _register(context)
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/logo.png'),
        ),
      ]
    );
  }
}
