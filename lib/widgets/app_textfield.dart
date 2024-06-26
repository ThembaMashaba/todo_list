import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 20,
        right: 20,
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}
