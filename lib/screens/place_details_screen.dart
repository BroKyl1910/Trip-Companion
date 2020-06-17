import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/distance_matrix_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_details_bloc.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailsScreen({this.placeId});

  Future<void> _moveCameraToLocation(
      BuildContext context, LatLng location) async {
    var cameraBloc = Provider.of<MapControllerBloc>(context, listen: false);
    cameraBloc.changeCameraPosition(location);
  }

  Widget _buildBody(
      BuildContext context,
      AsyncSnapshot<GooglePlaceResult> placeResultSnapshot,
      AsyncSnapshot<GoogleDistanceMatrix> distanceMatrixSnapshot) {
    if (placeResultSnapshot.hasData) {
      Location location = placeResultSnapshot.data.result.geometry.location;
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
                        placeResultSnapshot.hasData
                            ? Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            placeResultSnapshot.data.result.name,
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
                        _buildDetailsTitle(context, placeResultSnapshot),
                        SizedBox(height: 8),
                        _buildDetailsSubtitle(context, placeResultSnapshot),
                        SizedBox(
                          height: 8,
                        ),
                        _buildDetailsWidgets(context, placeResultSnapshot,
                            distanceMatrixSnapshot)
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var placeDetailsBloc =
        Provider.of<PlaceDetailsBloc>(context, listen: false);
    var distanceMatrixBloc =
        Provider.of<DistanceMatrixBloc>(context, listen: false);
    placeDetailsBloc.getPlaceDetails(placeId);
    distanceMatrixBloc.getDistanceMatrix(placeId);

    return StreamBuilder<GooglePlaceResult>(
        stream: placeDetailsBloc.placeStream,
        builder: (context, placeDetailsSnapshot) {
          return StreamBuilder<GoogleDistanceMatrix>(
              stream: distanceMatrixBloc.distanceMatrixStream,
              builder: (context, distanceMatrixSnapshot) {
                if (placeDetailsSnapshot.hasData &&
                    distanceMatrixSnapshot.hasData) {
                  return _buildBody(
                      context, placeDetailsSnapshot, distanceMatrixSnapshot);
                } else {
                  return _buildTopLoading();
                }
              });
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
            SizedBox(height: 40,),
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
      AsyncSnapshot<GooglePlaceResult> placeResultSnapshot) {
    return placeResultSnapshot.hasData
        ? Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              placeResultSnapshot.data.result.name,
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
      AsyncSnapshot<GooglePlaceResult> placeResultSnapshot) {
    return placeResultSnapshot.hasData
        ? Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              placeResultSnapshot.data.result.formattedAddress,
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

  Widget _buildDetailsWidgets(
      BuildContext context,
      AsyncSnapshot<GooglePlaceResult> placeResultSnapshot,
      AsyncSnapshot<GoogleDistanceMatrix> distanceMatrixSnapshot) {
    Widget ratingWidget = Container();
    Widget distanceWidget = Container();
    Widget durationWidget = Container();

    if (placeResultSnapshot.hasData &&
        placeResultSnapshot.data.result.rating != null) {
      double rating = placeResultSnapshot.data.result.rating;
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

    if (distanceMatrixSnapshot.hasData) {
      if (distanceMatrixSnapshot.data.rows[0].elements[0].distance != null) {
        String distance =
            distanceMatrixSnapshot.data.rows[0].elements[0].distance.text;
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

    if (distanceMatrixSnapshot.hasData) {
      if (distanceMatrixSnapshot.data.rows[0].elements[0].duration != null) {
        String duration =
            distanceMatrixSnapshot.data.rows[0].elements[0].duration.text;
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
}
