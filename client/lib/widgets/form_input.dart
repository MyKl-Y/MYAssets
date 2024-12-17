// client/lib/widgets/form_input.dart

/*
Input Field Stylized for Form
*/

import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String type;
  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData icon;
  final bool password;
  final TextInputType keyboardType;
  final String? Function(String?)? additionalValidator;

  FormInput({
    required this.type, 
    required this.controller, 
    required this.hint, 
    required this.label, 
    required this.icon, 
    required this.password, 
    required this.keyboardType,
    this.additionalValidator
  });

  @override 
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _obscureText = true;

  double _getDynamicFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600 ? baseSize : baseSize + 2;
  }

  @override
  Widget build(BuildContext context) {
    final passwords = <String, RegExp>{
      'at least one Lowercase letter': RegExp(r'[a-z]'),
      'at least one Uppercase letter': RegExp(r'[A-Z]'),
      'at least one Number from 0-9': RegExp(r'[a-zA-Z\d]'),
      'at least one Special Character (., !, @, #, \$, %, ^, &, *, -, _)': RegExp(r'[\.!@#$%^&*\-_]'),
      //'Must be at least 8 characters long': RegExp(r'[a-zA-Z\d#!@$%^&*-]{8,}')
    };
    final regExps = Map<String, RegExp>.from(passwords);

    return 
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          List<String> type = widget.type.split(' ');

          if (value == null || value.isEmpty) {
            return 'Must not leave ${type[0]} field blank';
          }

          if (RegExp(r'[^\S]').hasMatch(value)) {
            return 'Must not have whitespaces in ${type[0]} field';
          }

          if (type[0] == 'email') {
            if (!(RegExp(r'^(?=.*[\.@])[A-Za-z\d\.@$!%*?&\-_]{5,}$').hasMatch(value))) {
              return 'Must enter a valid email';
            }
          } else if (type[0] == 'password') {
            String message = '';

            if (value.length < 8) {
              return 'Password must contain at least 8 characters long';
            }

            regExps.forEach((key, val) {
              if (!val.hasMatch(value) && !(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\.@$!%*?&\-_])[A-Za-z\d\.@$!%*?&\-_]{8,}$').hasMatch(value))) {
                message += 'Password must contain $key';
              } else if (!(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\.@$!%*?&\-_])[A-Za-z\d\.@$!%*?&\-_]{8,}$').hasMatch(value))) {
                message = 'Password is invalid (Special Character and/or Alphanumerics)';
              }
            });

            if (message != '') return message;
          }

          if (widget.additionalValidator != null) {
            return widget.additionalValidator!(value);
          }
          
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          hintStyle: TextStyle(fontSize: _getDynamicFontSize(context, 12)),
          labelStyle: TextStyle(fontSize: _getDynamicFontSize(context, 14)),
          prefixIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.inversePrimary,),
          suffixIcon: widget.password
            ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: _obscureText 
                  ? Theme.of(context).colorScheme.inversePrimary 
                  : Theme.of(context).colorScheme.inverseSurface,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
          errorStyle: TextStyle(fontSize: _getDynamicFontSize(context, 10)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
        ),
        obscureText: widget.password ? _obscureText : false,
        keyboardType: widget.keyboardType,
      )
    );
  }
}