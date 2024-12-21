// client/lib/widgets/form_dropdown.dart

/*
Dropdown Field Stylized for Form
*/

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FormDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData icon;
  final bool hasDefaultValue;
  final Function(String?)? onChanged; // Add a callback

  const FormDropdown({
    required this.items,
    required this.controller,
    required this.hint,
    required this.label,
    required this.icon,
    required this.hasDefaultValue,
    this.onChanged, // Optional callback for changes
    super.key,
  });

  @override
  State<FormDropdown> createState() => FormDropdownState();
}

class FormDropdownState extends State<FormDropdown> {
  List<String> currentItems = [];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    currentItems = widget.items;
    dropdownValue = widget.hasDefaultValue && currentItems.isNotEmpty
        ? currentItems.first
        : null;
  }

  void resetItems(List<String> newItems) {
    setState(() {
      currentItems = newItems;
      dropdownValue = widget.hasDefaultValue && currentItems.isNotEmpty
          ? currentItems.first
          : null;
      widget.controller.text = dropdownValue ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.inversePrimary,),
          hintText: widget.hint,
          border: OutlineInputBorder(),
        ),
        value: dropdownValue,
        items: currentItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
            widget.controller.text = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value); // Trigger callback
          }
        },
      ),
    );
  }
}
