import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/data_preload_bloc.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/screens/main_app_controller.dart';

class DataPreloadScreen extends StatelessWidget {
  void setPermissions() async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return;
    }

    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    // Set map permissions
    setPermissions();

    //Load user info and pass to main controller
    var dataPreloadBloc = Provider.of<DataPreloadBloc>(context, listen: false);
    dataPreloadBloc.getLoggedInUserDetails();

    return StreamBuilder<User>(
        stream: dataPreloadBloc.userStream,
        builder: (context, snapshot) {
          bool loaded = snapshot.hasData;
          if (loaded) {
            return Provider<User>(
              create: (_) => snapshot.data,
              child: MainAppController(),
            );
          } else {
            return Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
