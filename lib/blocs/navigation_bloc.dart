import 'dart:async';

import 'package:rxdart/rxdart.dart';

class NavigationBloc{
  //Stream to control what screen is showing
  StreamController<Navigation> _navigationStreamController = new BehaviorSubject();
  Stream<Navigation> get navigationStream => _navigationStreamController.stream;

  void navigate(Navigation screen){
    _navigationStreamController.sink.add(screen);
  }

  //Stream gets added to when navigating so I can pass data to next screen
  StreamController<String> _placeIdController = new BehaviorSubject();
  Stream<String> get placeIdStream => _placeIdController.stream;

  void addPlace(String placeId){
    _placeIdController.sink.add(placeId);
  }

  //Stream gets added to when navigating so I can pass data to next screen
  StreamController<String> _searchQueryController = new BehaviorSubject();
  Stream<String> get searchQueryStream => _searchQueryController.stream;

  void addSearchQuery(String searchQuery){
    _searchQueryController.sink.add(searchQuery);
  }

  void dispose(){
    _navigationStreamController.close();
    _placeIdController.close();
    _searchQueryController.close();
  }
}

enum Navigation{
  HOME,
  SETTINGS,
  PLACE_DETAILS,
  SEARCH_RESULTS
}