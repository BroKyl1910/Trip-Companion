
import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_search_model.dart';
import 'package:tripcompanion/json_models/search_distance_matrix_model.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:http/http.dart'as http;

class PlaceSearchBloc{
  StreamController<SearchDistanceMatrixViewModel> _placeSearchResultController = new BehaviorSubject();
  Stream<SearchDistanceMatrixViewModel> get placeResultStream => _placeSearchResultController.stream;

  LatLng userLocation;
  Future<void> search(String query) async{
    if(userLocation == null){
      userLocation = await GeoLocatorLocation().getCurrentPosition();
    }
    print(userLocation);
    double radius = 50000;
    String userLocationStr = "${userLocation.latitude},${userLocation.longitude}";
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?input=$query&inputtype=textquery&fields=formatted_address,name,geometry&locationbias=circle:$radius@$userLocationStr&key=${Credentials.GOOGLE_API_KEY}";
    print(url);
    http.Response response = await http.get(url);
    GooglePlaceSearchResult result = GooglePlaceSearchResult.fromJson(json.decode(response.body));
    List<PlaceSearchResult> placeSearchResults = result.results;
    List<GoogleDistanceMatrix> distanceMatrices = new List();
    for(PlaceSearchResult res in placeSearchResults){
      if(userLocation == null){
        userLocation = await GeoLocatorLocation().getCurrentPosition();
      }
      print(userLocation);
      double radius = 2000;
      String userLocationStr = "${userLocation.latitude},${userLocation.longitude}";
      String url = "https://maps.googleapis.com/maps/api/distancematrix/json?key=${Credentials.GOOGLE_API_KEY}&origins=$userLocationStr&destinations=place_id:${res.placeId}";
      http.Response response = await http.get(url);
      GoogleDistanceMatrix distanceMatrix;
      distanceMatrix = GoogleDistanceMatrix.fromJson(json.decode(response.body));
      distanceMatrices.add(distanceMatrix);
    }
    SearchDistanceMatrixViewModel searchDistanceMatrix = new SearchDistanceMatrixViewModel(placeSearchResults, distanceMatrices);
    _placeSearchResultController.sink.add(searchDistanceMatrix);
  }

  void dispose(){
    _placeSearchResultController.close();
  }
}