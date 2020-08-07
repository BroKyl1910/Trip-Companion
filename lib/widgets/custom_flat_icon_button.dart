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
//    return FlatButton(
//      child: Row(
//        children: <Widget>[
//          Icon(
//            iconData,
//            color: iconColor,
//            size: 20.0,
//          ),
//          SizedBox(
//            width: 20,
//          ),
//          Text(text),
//        ],
//      ),
//      color: this.color,
//      textColor: this.textColor,
//      onPressed: onTapped,
//    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: this.onTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: iconColor,
                size: 20.0,
              ),
              SizedBox(
                width: 30,
              ),
              Text(text, style: TextStyle(
                color: this.textColor,
                fontSize: 14
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
