import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      {super.key,
      required this.label,
      required this.type,
      required this.validator,
      required this.onSaved,
      this.prefix});

  final String label;
  final TextInputType type;

  final Function(String? value) validator;
  final Function(String? value) onSaved;
  final String? prefix;

  @override
  Widget build(context) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(label),
        prefix: (prefix != null) ? Text(prefix.toString()) : const Text(""),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.error,
                style: BorderStyle.solid)),
      ),
      validator: (value) {
        return validator(value);
      },
      onSaved: (value) {
        if (value!.isNotEmpty) {
          onSaved(value);
        }
      },
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
