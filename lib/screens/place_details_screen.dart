import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_details_bloc.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;
  const PlaceDetailsScreen({this.placeId});

  Future<void> _moveCameraToLocation(BuildContext context, LatLng location) async {
    var cameraBloc =
        Provider.of<MapCameraControllerBloc>(context, listen: false);
    cameraBloc.changeCameraPosition(location);
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<GooglePlaceResult> snapshot) {
    if(snapshot.hasData){
      Location location = snapshot.data.result.geometry.location;
      _moveCameraToLocation(context, LatLng(location.lat, location.lng));
    }
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
                            var navBloc  = Provider.of<NavigationBloc>(context, listen: false);
                            navBloc.navigationStream.isBroadcast;
                            navBloc.navigate(Navigation.HOME);
                          },
                          splashColor: Color.fromARGB(130, 0, 0, 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    snapshot.hasData?
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        snapshot.data.result.name,
                        style: Theme.of(context).textTheme.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    :
                    Container(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PlaceDetailsBloc>(context, listen: false);
    bloc.getPlaceDetails(placeId);

    return StreamBuilder<GooglePlaceResult>(
      stream: bloc.placeStream,
      builder: (context, snapshot) {
        return _buildBody(context, snapshot);
      }
    );
  }
}
