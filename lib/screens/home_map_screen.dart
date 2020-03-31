import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tripcompanion/classes/firebase_authentication_helper.dart';
import 'package:tripcompanion/widgets/map_search_bar.dart';
import 'package:tripcompanion/widgets/navigation_bar.dart';

class HomeMapScreen extends StatefulWidget {
  final VoidCallback onSignOut;
  const HomeMapScreen({Key key, this.onSignOut}) : super(key: key);


  @override
  State<StatefulWidget> createState() => HomeMapScreenState(onSignOut: onSignOut);
}

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(-29.532519, 31.1973348);
const LatLng DEST_LOCATION = LatLng(-29.7974266, 31.0338298);

class HomeMapScreenState extends State<HomeMapScreen> {

  final VoidCallback onSignOut;
  HomeMapScreenState({this.onSignOut});

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition initialCameraPosition = CameraPosition(
    zoom: CAMERA_ZOOM,
    bearing: CAMERA_BEARING,
    tilt: CAMERA_TILT,
    target: SOURCE_LOCATION,
  );

  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  //TODO: Move this out of code to be more secure
  String googleAPIKey = "AIzaSyCqxBJe4fWNGCloV3a7BZYZe9lmfl4XNUE";

  @override
  Widget build(BuildContext context) {
    setPermissions();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
//      mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            polylines: _polylines,
            markers: _markers,
            mapToolbarEnabled: false,
            compassEnabled: false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                MapSearchBar(onTapped:(){
                  _scaffoldKey.currentState.openDrawer();
                },),
              ],
            ),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        onSignOut: onSignOut,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
//    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
//    setMapPins();
//    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(
          Marker(markerId: MarkerId('sourcePin'), position: SOURCE_LOCATION));
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: DEST_LOCATION,
      ));
    });
  }

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

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        SOURCE_LOCATION.latitude,
        SOURCE_LOCATION.longitude,
        DEST_LOCATION.latitude,
        DEST_LOCATION.longitude);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          width: 3,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
