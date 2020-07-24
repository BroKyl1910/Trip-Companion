import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_flat_icon_button.dart';

class NavigationDrawer extends StatelessWidget {

  Future<void> signOutUser(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e);
    }
  }

  void _getAuthenticationMethod(BuildContext context) async{
    final AuthBase auth = Provider.of<AuthBase>(context);
    print(await auth.getCurrentUserAuthenticationMethod());
  }

  @override
  Widget build(BuildContext context) {
    _getAuthenticationMethod(context);
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
