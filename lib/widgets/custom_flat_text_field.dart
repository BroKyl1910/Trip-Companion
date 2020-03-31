import 'package:flutter/material.dart';

class CustomFlatTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscured;
  final Function onChanged;
  final TextEditingController textEditingController;

  const CustomFlatTextField({
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    this.obscured: false,
    this.onChanged,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            obscureText: obscured,
            keyboardType: keyboardType,
            onChanged: onChanged,
            controller: textEditingController,
          ),
        ),
      ),
    );
  }
}
