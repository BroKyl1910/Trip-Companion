import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/search_maps_bloc.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:tripcompanion/widgets/map_search_bar.dart';

class PlaceDetailsScreen extends StatelessWidget {
  Future<void> _moveCameraToLocation(BuildContext context) async {
    var cameraBloc =
        Provider.of<MapCameraControllerBloc>(context, listen: false);
    LatLng myLocation = await GeoLocatorLocation().getCurrentPosition();
    cameraBloc.changeCameraPosition(myLocation);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            //Top bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          splashColor: Color.fromARGB(130, 0, 0, 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Place Details',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
