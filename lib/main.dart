import 'package:flutter/material.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/screens/register_screen.dart';

import 'screens/home_map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      // Define app's routes
      routes: {
        '/login': (context) => LoginScreen(),
        '/register' : (context) => RegisterScreen(),
        '/home': (context) => HomeMapScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
