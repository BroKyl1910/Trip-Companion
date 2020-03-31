import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {

  final String text;
  final Color textColor;
  final Color color;
  final Function onTapped;

  const CustomFlatButton({
    this.text : '',
    this.textColor : Colors.black,
    this.color : Colors.white,
    this.onTapped
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      color: this.color,
      textColor: this.textColor,
      onPressed: onTapped,
    );
  }
}
