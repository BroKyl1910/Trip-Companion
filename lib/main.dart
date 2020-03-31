import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/landing_screen.dart';
import 'package:tripcompanion/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingScreen(
        auth: Auth(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
