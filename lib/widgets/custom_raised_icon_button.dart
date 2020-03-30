import 'package:flutter/material.dart';

class CustomRaisedIconButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final IconData iconData;

  CustomRaisedIconButton({
    this.text : '',
    this.onTap,
    this.color : Colors.black,
    this.textColor : Colors.white,
    this.iconData,
    this.iconColor,
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
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              size: 30.0,
              color: iconColor,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onPressed: onTap,
    );
  }
}
