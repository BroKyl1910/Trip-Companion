import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/home_map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // Define app's routes
      routes: {
        '/home': (context) => HomeMapScreen()
      },
    );
  }
}
