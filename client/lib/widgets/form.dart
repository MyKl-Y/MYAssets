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
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 5, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width > 769 
              ? MediaQuery.of(context).size.width * (3 / 8)
              : MediaQuery.of(context).size.width * (7 / 8),
            maxHeight: 50 + (widget.children.length * 60) + 50
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: Text(widget.formName),),
            body: Form(
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
    );
  }
}