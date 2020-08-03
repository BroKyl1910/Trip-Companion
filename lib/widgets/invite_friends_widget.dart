import 'package:flutter/material.dart';

class InviteFriendsWidget extends StatefulWidget {
  @override
  _InviteFriendsWidgetState createState() => _InviteFriendsWidgetState();

  final Function handleCloseDialog;
  final Function handleSaveList;

  InviteFriendsWidget({this.handleCloseDialog, this.handleSaveList});

}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(120, 0, 0, 0),
            offset: Offset(2.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[400],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  //Top bar
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Invite Friends',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        iconSize: 20.0,
                                        color: Colors.white,
                                        onPressed: () {
                                          widget.handleCloseDialog(context);
                                        },
                                        splashColor: Color.fromARGB(130, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        iconSize: 20.0,
                                        color: Colors.white,
                                        onPressed: () {
                                          widget.handleSaveList(context);
                                        },
                                        splashColor: Color.fromARGB(130, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      // Listview of friends
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
