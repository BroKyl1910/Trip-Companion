import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/data_preload_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/screens/data_preload_screen.dart';
import 'package:tripcompanion/screens/login_screen.dart';
import 'package:tripcompanion/screens/main_app_controller.dart';
import 'package:tripcompanion/services/auth.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthBase>(context, listen: false).onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //No user
            return LoginScreen.create(context);
          }
          //User has logged in
          return Provider<MapControllerBloc>(
            create: (_) => MapControllerBloc(),
            dispose: (context, bloc) => bloc.dispose(),
            child: Provider<NavigationBloc>(
              create: (_) => NavigationBloc(),
              dispose: (context, bloc) => bloc.dispose(),
              child: Provider<DataPreloadBloc>(
                create: (_) => DataPreloadBloc(),
                dispose: (context, bloc) => bloc.dispose(),
                child: DataPreloadScreen(),
              ),
            ),
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
