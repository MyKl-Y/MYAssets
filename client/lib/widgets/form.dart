// client/lib/widgets/form.dart

/*
Stylized Form
*/

import 'package:flutter/material.dart';

import 'form_submit_button.dart';

class BasicForm extends StatefulWidget {
  final List<Widget> children;
  final String formName;
  final String submitButtonText;
  final Function submitButtonCallback;

  BasicForm(this.children, this.formName, this.submitButtonText, this.submitButtonCallback, {super.key});

  @override 
  State<BasicForm> createState() => _BasicFormState();
}

class _BasicFormState extends State<BasicForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: Text(widget.formName, style: TextStyle(color: Theme.of(context).colorScheme.surface)), 
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).primaryIconTheme,
      ),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width / 2),
            child: Card(
              elevation: 5, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.children, 
                      FormSubmitButton(widget.submitButtonText, widget.submitButtonCallback, _formKey)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}