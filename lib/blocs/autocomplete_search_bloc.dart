import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_autocomplete_model.dart';
import 'package:tripcompanion/services/location.dart';

class AutocompleteSearchBloc{
  StreamController<GoogleAutocompleteResult> _autocompleteStreamController = new StreamController();
  Stream<GoogleAutocompleteResult> get autoCompleteStream => _autocompleteStreamController.stream;

  LatLng userLocation;
  Future<void> search(String query) async{
    if(userLocation == null){
      userLocation = await GeoLocatorLocation().getCurrentPosition();
    }
    print(userLocation);
    double radius = 2000;
    String userLocationStr = "${userLocation.latitude},${userLocation.longitude}";
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${Credentials.GOOGLE_API_KEY}&input=$query&origin=$userLocationStr&location=$userLocationStr&radius=$radius";
    http.Response response = await http.get(url);
    GoogleAutocompleteResult result = GoogleAutocompleteResult.fromJson(json.decode(response.body));
    _autocompleteStreamController.sink.add(result);
  }

  void dispose(){
    _autocompleteStreamController.close();
  }
}