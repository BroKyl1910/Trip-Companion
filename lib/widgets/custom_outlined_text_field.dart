import 'package:flutter/material.dart';

class CustomOutlinedTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscured;

  const CustomOutlinedTextField({
    this.hintText : '',
    this.keyboardType : TextInputType.text,
    this.obscured : false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromARGB(20, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                offset: Offset(1, 1),
                blurRadius: 3),
          ],
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
              keyboardType: keyboardType),
        ),
      ),
    );
  }
}
