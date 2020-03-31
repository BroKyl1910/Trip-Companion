import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_flat_icon_button.dart';

class NavigationDrawer extends StatelessWidget {
  final VoidCallback onSignOut;
  final AuthBase auth;
  NavigationDrawer({this.onSignOut, this.auth});

  Future<void> signOutUser() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomFlatIconButton(
            iconData: Icons.exit_to_app,
            text: 'Log Out',
            textColor: Colors.black54,
            iconColor: Colors.black54,
            color: Colors.transparent,
            onTapped: () async {
              Navigator.pop(context);
              await signOutUser();
            },
          )
        ],
      ),
    );
  }
}
