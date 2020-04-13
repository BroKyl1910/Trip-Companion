import 'dart:async';

import 'package:tripcompanion/json_models/google_place_model.dart';

class NavigationBloc{
  //Stream to control what screen is showing
  StreamController<Navigation> _navigationStreamController = new StreamController();
  Stream<Navigation> get navigationStream => _navigationStreamController.stream;

  void navigate(Navigation screen){
    _navigationStreamController.sink.add(screen);
  }

  //Stream gets added to when navigating so I can pass data to next screen
  StreamController<String> _placeIdController = new StreamController();
  Stream<String> get placeIdStream => _placeIdController.stream;

  void addPlace(String placeId){
    _placeIdController.sink.add(placeId);
  }

  void dispose(){
    _navigationStreamController.close();
    _placeIdController.close();
  }
}

enum Navigation{
  HOME,
  SETTINGS,
  PLACE_DETAILS
}