import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          //Background image and overlay
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Image(
              image: AssetImage('assets/images/map_backgrounds/map_1.PNG'),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(120, 0, 0, 0),
            ),
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  //Top bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(120, 0, 0, 0),
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Material(
                              type: MaterialType.transparency,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                iconSize: 20.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                splashColor: Color.fromARGB(130, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            'Register',
                            style: Theme.of(context).textTheme.title,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
