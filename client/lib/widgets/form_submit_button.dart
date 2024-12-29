// client/lib/widgets/form_submit_button.dart

/*
Button Stylized for Form Submit
*/

import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final String text;
  final Function callback;
  final GlobalKey<FormState> formKey;

  FormSubmitButton(this.text, this.callback, this.formKey);

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: FilledButton(
          onPressed: () { if (formKey.currentState!.validate()) { callback(); } },
          child: Text(
            text, 
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 22),
          ),
        ),
      ),
    );
  }
}