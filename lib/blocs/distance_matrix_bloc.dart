import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:http/http.dart' as http;

class DistanceMatrixBloc{
  StreamController<GoogleDistanceMatrix> _distanceMatrix = new BehaviorSubject();
  Stream<GoogleDistanceMatrix> get distanceMatrixStream => _distanceMatrix.stream;

  LatLng userLocation;
  Future<void> getDistanceMatrix(String placeId) async {
    if(userLocation == null){
      userLocation = await GeoLocatorLocation().getCurrentPosition();
    }
    print(userLocation);
    double radius = 2000;
    String userLocationStr = "${userLocation.latitude},${userLocation.longitude}";
    String url = "https://maps.googleapis.com/maps/api/distancematrix/json?key=${Credentials.GOOGLE_API_KEY}&origins=$userLocationStr&destinations=place_id:$placeId";
    http.Response response = await http.get(url);
    GoogleDistanceMatrix result = GoogleDistanceMatrix.fromJson(json.decode(response.body));
    _distanceMatrix.sink.add(result);
  }

  void dispose(){
    _distanceMatrix.close();
  }
}