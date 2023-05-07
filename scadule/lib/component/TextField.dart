import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final keyboardType;
  final bool autofocus;
  final focusNode;
  final int maxLines;
  final labelText;
  final Function(String result) onChanged;

  const MyTextfield({
    super.key,
    this.keyboardType,
    this.labelText,
    required this.onChanged,
    required this.maxLines,
    required this.controller,
    required this.autofocus,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      focusNode: focusNode,
      maxLines: maxLines,
      style: TextStyle(
        color: context.theme.colorScheme.onBackground,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: context.theme.colorScheme.onBackground,
        ),
        filled: true,
        fillColor: context.theme.colorScheme.surface,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.colorScheme.onBackground,
          ),
        ),
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.next,
      cursorColor: context.theme.colorScheme.onBackground,
    );
  }
}
