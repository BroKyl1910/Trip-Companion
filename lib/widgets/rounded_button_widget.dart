import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color color;
  final double width;

  RoundedButton({
    this.text,
    this.onTap,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: this.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(60, 0, 0, 0),
                offset: Offset(2.0, 3.0),
                blurRadius: 3.0),
          ],
        ),
      ),
      onTap: this.onTap,
    );
  }
}
