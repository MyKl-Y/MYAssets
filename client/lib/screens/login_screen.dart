// client/lib/screens/login_screen.dart

/*
UI Screen: Login Screen
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:google_fonts/google_fonts.dart';

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
                      type: 'password', 
                      controller: passwordController, 
                      hint: 'Password', 
                      label: 'Password', 
                      icon: Icons.key, 
                      password: true, 
                      keyboardType: TextInputType.visiblePassword
                    ),
                  ],
                  childrenAfterSubmit: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 60,
                            ),
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: //Icon(Icons.g_mobiledata),
                            Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: //Icon(Icons.g_mobiledata),
                            Image.network(
                              'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text("Register here"),
                        ),
                      ],
                    ),
                  ], 
                  formName: 'Login', 
                  submitButtonText: 'Login', 
                  submitButtonCallback: () => _login(context)
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
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
                      type: 'password', 
                      controller: passwordController, 
                      hint: 'Password', 
                      label: 'Password', 
                      icon: Icons.key, 
                      password: true, 
                      keyboardType: TextInputType.visiblePassword
                    ),
                  ],
                  childrenAfterSubmit: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 60,
                            ),
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: //Icon(Icons.g_mobiledata),
                            Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: //Icon(Icons.g_mobiledata),
                            Image.network(
                              'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text("Register here"),
                        ),
                      ],
                    ),
                  ], 
                  formName: 'Login', 
                  submitButtonText: 'Login', 
                  submitButtonCallback: () => _login(context)
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
