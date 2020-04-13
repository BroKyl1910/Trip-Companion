import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';

class PlaceDetailsBloc{
  StreamController<GooglePlaceResult> _placeStream = new StreamController();
  Stream<GooglePlaceResult> get placeStream => _placeStream.stream;

  Future<void> getPlaceDetails(String placeId) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?key=${Credentials.GOOGLE_API_KEY}&place_id=$placeId";
    http.Response response = await http.get(url);
    GooglePlaceResult result = GooglePlaceResult.fromJson(json.decode(response.body));
    _placeStream.sink.add(result);
  }

  void dispose(){
    _placeStream.close();
  }
}