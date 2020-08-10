import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogHelper{
  static showConfirmationDialog(BuildContext context, String message, Function callback)async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ACCEPT'),
              onPressed: () async {
                await callback();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }
}