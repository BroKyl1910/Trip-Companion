import 'package:flutter/material.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/screens/home_map_screen.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/auth_provider.dart';

class LandingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthProvider.of(context).onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //No user
            return LoginScreen();
          }
          //User has logged in
          return HomeMapScreen();
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
