import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripcompanion/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:tripcompanion/repositories/user_repository.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/screens/register_screen.dart';

import 'blocs/simple_bloc_delegate.dart';
import 'screens/home_map_screen.dart';
=======
import 'package:provider/provider.dart';
import 'package:tripcompanion/screens/landing_screen.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/db.dart';
>>>>>>> StartingAndrea

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      initialRoute: '/login',
      // Define app's routes
      routes: {
        '/login': (context) {
          WidgetsFlutterBinding.ensureInitialized();
          BlocSupervisor.delegate = SimpleBlocDelegate();
          final UserRepository userRepository = UserRepository();
          return BlocProvider(
            create: (context) => AuthenticationBloc(userRepository: userRepository)
            ..add(AppStarted()),
            child: LoginScreen(key, userRepository),
          );
        },
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeMapScreen(),
      },
      debugShowCheckedModeBanner: false,
=======
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: Provider<DatabaseBase>(
        create: (_) => FirestoreDatabase(),
        child: MaterialApp(
          home: LandingScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
>>>>>>> StartingAndrea
    );
  }
}
