import 'package:flutter/material.dart';

class CustomFlatIconButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color color;
  final Function onTapped;
  final IconData iconData;
  final Color iconColor;

  const CustomFlatIconButton(
      {this.text: '',
      this.textColor: Colors.black,
      this.color: Colors.white,
      this.onTapped,
      this.iconColor: Colors.black,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            color: iconColor,
            size: 20.0,
          ),
          SizedBox(
            width: 20,
          ),
          Text(text),
        ],
      ),
      color: this.color,
      textColor: this.textColor,
      onPressed: onTapped,
    );
  }
}
