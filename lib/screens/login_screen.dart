import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripcompanion/screens/register_screen.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_outlined_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';
import 'package:tripcompanion/widgets/custom_raised_icon_button.dart';

class LoginScreen extends StatelessWidget {
  final AuthBase auth;
  final Function(User) onSignIn;

  LoginScreen({@required this.auth, @required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/logo.png'),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  CustomOutlinedTextField(
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    obscured: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomOutlinedTextField(
                                    hintText: 'Password',
                                    keyboardType: TextInputType.text,
                                    obscured: true,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomRaisedButton(
                                    color: Colors.blue[400],
                                    textColor: Colors.white,
                                    text: 'Login',
                                    onTap: () {},
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child:
                                                Divider(color: Colors.white)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "OR",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomRaisedIconButton(
                                    color: Colors.red[400],
                                    textColor: Colors.white,
                                    text: 'Login with Google',
                                    onTap: () {
                                      auth
                                          .signInWithGoogle()
                                          .whenComplete(() async {
                                        onSignIn(await auth.currentUser());
                                      }).catchError(
                                              (Object error, StackTrace st) {
                                        print(error.toString());
                                      });
                                    },
                                    iconData: FontAwesomeIcons.google,
                                    iconColor: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      Container(
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Not a member yet? Sign up',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(auth:auth),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
