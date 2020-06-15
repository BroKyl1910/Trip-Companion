
import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_place_search_model.dart';
import 'package:tripcompanion/services/location.dart';
import 'package:http/http.dart'as http;

class PlaceSearchBloc{
  StreamController<GooglePlaceSearchResult> _placeSearchResultController = new BehaviorSubject();
  Stream<GooglePlaceSearchResult> get placeResultStream => _placeSearchResultController.stream;

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
    print("Result added");
    _placeSearchResultController.sink.add(result);
  }

  void dispose(){
    _placeSearchResultController.close();
  }
}