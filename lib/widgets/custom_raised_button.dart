import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color color;
  final Color textColor;

  CustomRaisedButton({
    this.text : '',
    this.onTap,
    this.color : Colors.white,
    this.textColor : Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 15.0, fontWeight: FontWeight.bold,),
        ),
      ),
      onPressed: onTap,
    );
  }
}
