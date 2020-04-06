import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/landing_screen.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        home: LandingScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
