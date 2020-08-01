import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';
import 'package:tripcompanion/services/location.dart';

class PlaceDistanceMatrixBloc {
  StreamController<PlaceDistanceMatrixViewModel> _streamController =
      new BehaviorSubject();

  Stream<PlaceDistanceMatrixViewModel> get placeDistanceMatrixStream =>
      _streamController.stream;

  Future<void> getPlaceDetailsAndDistance(String placeId) async {
    // Get Place Details
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=${Credentials.GOOGLE_API_KEY}&place_id=$placeId";
    print(url);
    http.Response response = await http.get(url);
    GooglePlaceResult placeResult =
        GooglePlaceResult.fromJson(json.decode(response.body));

    //Get Distance Matrix
    LatLng userLocation = await GeoLocatorLocation().getCurrentPosition();

    print(userLocation);
    double radius = 2000;
    String userLocationStr =
        "${userLocation.latitude},${userLocation.longitude}";
    url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?key=${Credentials.GOOGLE_API_KEY}&origins=$userLocationStr&destinations=place_id:$placeId";
    response = await http.get(url);
    GoogleDistanceMatrix distanceMatrixResult =
        GoogleDistanceMatrix.fromJson(json.decode(response.body));

    PlaceDistanceMatrixViewModel viewModel = new PlaceDistanceMatrixViewModel(placeResult, distanceMatrixResult);
    _streamController.add(viewModel);
  }

  void dispose() {
    _streamController.close();
  }
}
