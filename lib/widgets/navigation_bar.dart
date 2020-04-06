import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/auth_provider.dart';
import 'package:tripcompanion/widgets/custom_flat_icon_button.dart';

class NavigationDrawer extends StatelessWidget {

  Future<void> signOutUser(BuildContext context) async {
    try {
      await AuthProvider.of(context).signOut();
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
              await signOutUser(context);
            },
          )
        ],
      ),
    );
  }
}
