import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stack/stack.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';

class NavigationBloc{
  static Stack<Navigation> screens = Stack();

  //Stream to control what screen is showing
  StreamController<Navigation> _navigationStreamController = new BehaviorSubject();
  Stream<Navigation> get navigationStream => _navigationStreamController.stream;

  void addToNavStack(Navigation screen){
    screens.push(screen);
  }

  void back(){
    if(screens.isNotEmpty){
      screens.pop();
      var screen = screens.top();
      _navigationStreamController.sink.add(screen);
    }else{
      throw Exception();
    }

  }

  void navigate(Navigation screen){
    screens.push(screen);
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

  //Stream gets added to when navigating so I can pass data to next screen
  StreamController<PlaceDistanceMatrixViewModel> _placeDistanceMatrixController = new BehaviorSubject();
  Stream<PlaceDistanceMatrixViewModel> get placeDistanceMatrixStream => _placeDistanceMatrixController.stream;

  void addPlaceDistanceMatrix(PlaceDistanceMatrixViewModel viewModel){
    _placeDistanceMatrixController.sink.add(viewModel);
  }

  void dispose(){
    _navigationStreamController.close();
    _placeIdController.close();
    _searchQueryController.close();
    _placeDistanceMatrixController.close();
  }
}

enum Navigation{
  HOME,
  SETTINGS,
  PLACE_DETAILS,
  SEARCH_RESULTS,
  CREATE_EVENT,
  FRIENDS
}