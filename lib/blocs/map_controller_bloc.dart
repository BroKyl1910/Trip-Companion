import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCameraControllerBloc{
  //Control movement of camera
  StreamController<CameraUpdate> _mapCameraStreamController = new StreamController();
  Stream<CameraUpdate> get mapCameraStream => _mapCameraStreamController.stream;

  void changeCameraPosition(LatLng newPosition){
    // Make camera update from new position
    _mapCameraStreamController.sink.add(CameraUpdate.newLatLng(newPosition));
  }

  void dispose(){
    _mapCameraStreamController.close();
  }
}