import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/json_models/google_autocomplete_model.dart';

class SearchMapsBloc{
  StreamController<GoogleAutocompleteResult> _autocompleteStreamController = new StreamController();
  Stream<GoogleAutocompleteResult> get autoCompleteStream => _autocompleteStreamController.stream;

  Future<void> autocomplete(String query) async{
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${Credentials.GOOGLE_API_KEY}&input=$query";
    http.Response response = await http.get(url);
    GoogleAutocompleteResult result = GoogleAutocompleteResult.fromJson(json.decode(response.body));
    _autocompleteStreamController.sink.add(result);
  }

  void dispose(){
    _autocompleteStreamController.close();
  }
}