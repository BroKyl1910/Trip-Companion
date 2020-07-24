import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/distance_matrix_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_details_bloc.dart';
import 'package:tripcompanion/blocs/place_distance_matrix_bloc.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailsScreen({this.placeId});

  Future<void> _moveCameraToLocation(
      BuildContext context, LatLng location) async {
    var cameraBloc = Provider.of<MapControllerBloc>(context, listen: false);
    cameraBloc.changeCameraPosition(location);
  }

  Widget _buildBody(BuildContext context,
      AsyncSnapshot<PlaceDistanceMatrixViewModel> snapshot) {
    if (snapshot.hasData) {
      Location location = snapshot.data.PlaceResult.result.geometry.location;
      LatLng placeLatLng = LatLng(location.lat, location.lng);
      _moveCameraToLocation(context, placeLatLng);

      var mapBloc = Provider.of<MapControllerBloc>(context, listen: false);
      Marker marker =
          Marker(markerId: MarkerId(placeId), position: placeLatLng);
      Set<Marker> markers = new Set();
      markers.add(marker);
      mapBloc.showMarkers(markers);
    }

    return Container(
      constraints: BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Top bar
            Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
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
                                var navBloc = Provider.of<NavigationBloc>(
                                    context,
                                    listen: false);
                                var mapBloc = Provider.of<MapControllerBloc>(
                                    context,
                                    listen: false);
                                mapBloc.removeMarkers();
                                navBloc.navigate(Navigation.HOME);
                              },
                              splashColor: Color.fromARGB(130, 0, 0, 0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        snapshot.hasData
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  snapshot.data.PlaceResult.result.name,
                                  style: Theme.of(context).textTheme.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Container(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black12,
                                  ),
                                ),
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

            //Bottom Place Details Block
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            await navigationButtonPressed(snapshot);
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38),
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(120, 0, 0, 0),
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0)
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.navigation,
                                  color: Colors.white,
                                ),
                                Text(
                                  'GO',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildDetailsTitle(context, snapshot),
                            SizedBox(height: 8),
                            _buildDetailsSubtitle(context, snapshot),
                            SizedBox(
                              height: 8,
                            ),
                            _buildDetailsWidgets(context, snapshot)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var placeDistanceMatrixBloc =
        Provider.of<PlaceDistanceMatrixBloc>(context, listen: false);
    placeDistanceMatrixBloc.getPlaceDetailsAndDistance(placeId);

    return StreamBuilder<PlaceDistanceMatrixViewModel>(
        stream: placeDistanceMatrixBloc.placeDistanceMatrixStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildBody(context, snapshot);
          } else {
            return _buildTopLoading();
          }
        });
  }

  Widget _buildTopLoading() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.black12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsTitle(BuildContext context,
      AsyncSnapshot<PlaceDistanceMatrixViewModel> snapshot) {
    return snapshot.hasData
        ? Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              snapshot.data.PlaceResult.result.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)),
          );
  }

  Widget _buildDetailsSubtitle(BuildContext context,
      AsyncSnapshot<PlaceDistanceMatrixViewModel> snapshot) {
    return snapshot.hasData
        ? Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              snapshot.data.PlaceResult.result.formattedAddress,
              style: TextStyle(
                color: Color.fromARGB(125, 0, 0, 0),
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)),
          );
  }

  Widget _buildDetailsWidgets(BuildContext context,
      AsyncSnapshot<PlaceDistanceMatrixViewModel> snapshot) {
    Widget ratingWidget = Container();
    Widget distanceWidget = Container();
    Widget durationWidget = Container();

    if (snapshot.hasData && snapshot.data.PlaceResult.result.rating != null) {
      double rating = snapshot.data.PlaceResult.result.rating;
      ratingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Color.fromARGB(255, 255, 215, 0),
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "$rating",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 200, 200, 0),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
    }

    if (snapshot.hasData) {
      if (snapshot.data.DistanceMatrix.rows[0].elements[0].distance != null) {
        String distance =
            snapshot.data.DistanceMatrix.rows[0].elements[0].distance.text;
        distanceWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.navigation,
              size: 20,
              color: Color.fromARGB(125, 0, 0, 0),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "$distance",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(125, 0, 0, 0),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      }
    }

    if (snapshot.hasData) {
      if (snapshot.data.DistanceMatrix.rows[0].elements[0].duration != null) {
        String duration =
            snapshot.data.DistanceMatrix.rows[0].elements[0].duration.text;
        durationWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.directions_car,
              size: 20,
              color: Color.fromARGB(125, 0, 0, 0),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "$duration",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(125, 0, 0, 0),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      }
    }

    return Row(
      children: <Widget>[
        ratingWidget,
        distanceWidget,
        durationWidget,
      ],
    );
  }

  navigationButtonPressed(AsyncSnapshot<PlaceDistanceMatrixViewModel> snapshot) async {
    LatLng userLocation = await GeoLocatorLocation().getCurrentPosition();
    String userLocationStr = "${userLocation.latitude},${userLocation.longitude}";
    Location destination = snapshot.data.PlaceResult.result.geometry.location;
    LatLng destinationLatLng = LatLng(destination.lat, destination.lng);
    String destinationLocationStr = "${destinationLatLng.latitude},${destinationLatLng.longitude}";
    String url = 'https://www.google.com/maps/dir/?api=1&origin=$userLocationStr&destination=$destinationLocationStr&travelmode=driving&dir_action=navigate';
    _launchURL(url);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
