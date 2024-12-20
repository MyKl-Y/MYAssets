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

  const FormDropdown({
    required this.items, 
    required this.controller,
    required this.hint,
    required this.label,
    required this.icon,
    super.key
  });

  @override
  State<FormDropdown> createState() => _FormDropdownState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _FormDropdownState extends State<FormDropdown> {

  @override
  Widget build(BuildContext context) {
    final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
      widget.items.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
    );
    String dropdownValue = '';

    return Padding(
      padding: const EdgeInsets.all(5.0), 
      child:LayoutBuilder(
        builder: (context, constraints) {
          return DropdownMenu<String>(
            width: constraints.maxWidth,
            controller: widget.controller,
            label: Text(widget.label),
            hintText: widget.hint,
            leadingIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.inversePrimary,),
            //initialSelection: widget.items.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            dropdownMenuEntries: menuEntries,
          );
        }
      )
    );
  }
}
