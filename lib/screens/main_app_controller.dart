import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/screens/home_screen.dart';
import 'package:tripcompanion/widgets/map_search_bar.dart';
import 'package:tripcompanion/widgets/map_widget.dart';
import 'package:tripcompanion/widgets/navigation_bar.dart';

class MainAppController extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final User user;
  MainAppController({this.user});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
      drawer: NavigationDrawer(),
    );
  }

  Widget _buildBody(BuildContext context){
    return Stack(
      children: <Widget>[
        StreamBuilder<CameraUpdate>(
          stream: Provider.of<MapCameraControllerBloc>(context).mapCameraStream,
          builder: (context, snapshot) {
            return MapWidget(cameraUpdate: snapshot.data,);
          }
        ),
        HomeScreen(scaffoldKey: _scaffoldKey),
      ],
    );
  }

}
