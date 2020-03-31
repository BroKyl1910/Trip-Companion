import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/home_map_screen.dart';
import 'package:tripcompanion/screens/login_screen.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    _updateUser(user);
  }

  void _updateUser(FirebaseUser user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoginScreen(
        onSignIn: (user) => _updateUser(user),
      );
    }
    return HomeMapScreen(
      onSignOut: () => _updateUser(null),
    );
  }
}
