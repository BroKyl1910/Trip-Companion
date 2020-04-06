import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String errorMessage;
  final Function onClosed;
  final AnimationController animationController;

  ErrorDialog({this.errorMessage, this.onClosed, this.animationController});

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog>{


  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                offset: Offset(2, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    widget.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white70,
                      onPressed: widget.onClosed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
