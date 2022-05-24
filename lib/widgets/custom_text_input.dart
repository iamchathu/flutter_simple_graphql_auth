import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.textInputAction,
    this.onEditingComplete,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: labelText,
      ),
      inputFormatters: inputFormatters,
      validator: validator,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
    );
  }
}
