import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:tripcompanion/widgets/map_search_bar.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeScreen({this.scaffoldKey});

  Future<void> _moveCameraToMyLocation(BuildContext context) async{
    var cameraBloc = Provider.of<MapCameraControllerBloc>(context, listen: false);
    LatLng myLocation = await GeoLocatorLocation().getCurrentPosition();
    cameraBloc.changeCameraPosition(myLocation);
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              MapSearchBar(
                onTapped: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                _moveCameraToMyLocation(context);
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
