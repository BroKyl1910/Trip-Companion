import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/home_map_screen.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/services/auth.dart';

class LandingScreen extends StatefulWidget {
  final AuthBase auth;

  const LandingScreen({this.auth});
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    var user = await widget.auth.currentUser();
    _updateUser(user);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoginScreen(
        auth: widget.auth,
        onSignIn: (user) => _updateUser(user),
      );
    }
    return HomeMapScreen(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }
}
