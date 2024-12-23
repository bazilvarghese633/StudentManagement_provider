import 'package:flutter/material.dart';
import 'package:student_provider_try1/core/constants.dart';

class CustomTextformField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyBoardType;

  const CustomTextformField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.validator,
      this.keyBoardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      keyboardType: keyBoardType,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontFamily: 'poppins'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: focusedBorder),
    );
  }
}
