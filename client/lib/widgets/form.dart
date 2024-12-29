// client/lib/widgets/form.dart

/*
Stylized Form
*/

import 'package:flutter/material.dart';

import 'form_submit_button.dart';

class BasicForm extends StatefulWidget {
  final List<Widget>? childrenBeforeSubmit;
  final List<Widget>? childrenAfterSubmit;
  final String formName;
  final String submitButtonText;
  final Function submitButtonCallback;

  BasicForm({
    this.childrenBeforeSubmit = const [], 
    this.childrenAfterSubmit = const [],
    required this.formName, 
    required this.submitButtonText, 
    required this.submitButtonCallback, 
    super.key
  });

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
            maxHeight: 
              50 // Heading
              + (widget.childrenBeforeSubmit!.length * 75) // Before (10 for padding, 15 for error)
              + (widget.childrenAfterSubmit!.length * 50) // After (0 for padding)
              + 50 // Padding + Submit Button
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
                  ...widget.childrenBeforeSubmit ?? [], 
                  FormSubmitButton(widget.submitButtonText, widget.submitButtonCallback, _formKey),
                  ...widget.childrenAfterSubmit ?? [], 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}