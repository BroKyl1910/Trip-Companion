import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/home_map_screen.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/services/auth.dart';

class LandingScreen extends StatelessWidget {
  final AuthBase auth;

  const LandingScreen({this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //No user
            return LoginScreen(
              auth: auth,
            );
          }
          //User has logged in
          return HomeMapScreen(
            auth: auth,
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
