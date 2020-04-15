import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCameraControllerBloc{
  //Control movement of camera
  StreamController<CameraUpdate> _mapCameraStreamController = new StreamController<CameraUpdate>.broadcast();
  Stream<CameraUpdate> get mapCameraStream => _mapCameraStreamController.stream.asBroadcastStream();

  void changeCameraPosition(LatLng newPosition){
    // Make camera update from new position
    _mapCameraStreamController.sink.add(CameraUpdate.newLatLng(newPosition));
  }

  void dispose(){
    _mapCameraStreamController.close();
  }
}