// client/lib/screens/register_screen.dart

/*
UI Screen: Register Screen
*/

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

import '../widgets/form_input.dart';
import '../widgets/form.dart';

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
          Navigator.of(context).maybePop(); // Navigate back to login screen
        }
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
    return Container(
      color: Theme.of(context).colorScheme.inverseSurface,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 769) {
          return Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height / 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/m.y logo.png'),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10), 
                      child: Text(
                        ' Assets',
                        style: GoogleFonts.audiowide(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: MediaQuery.of(context).size.height / 8 - 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height * (7 / 8),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Navigate back to Login
                          child: Text('Login here'),
                        ),
                      ],
                    ),
                  ], 
                  formName: 'Register', 
                  submitButtonText: 'Register', 
                  submitButtonCallback: () => _register(context)
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Navigate back to Login
                          child: Text('Login here'),
                        ),
                      ],
                    ),
                  ], 
                  formName: 'Register', 
                  submitButtonText: 'Register', 
                  submitButtonCallback: () => _register(context)
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                //padding: EdgeInsets.only(left: 120),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20), 
                      child: Image.asset('assets/images/m.y logo.png'),
                    ),
                    Text(
                      'Assets',
                      style: GoogleFonts.audiowide(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
