import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapControllerBloc{
  //Control movement of camera
  StreamController<CameraUpdate> _mapCameraStreamController = new BehaviorSubject();
  Stream<CameraUpdate> get mapCameraStream => _mapCameraStreamController.stream;

  void changeCameraPosition(LatLng newPosition){
    // Make camera update from new position
    _mapCameraStreamController.sink.add(CameraUpdate.newLatLng(newPosition));
  }

  StreamController<Set<Marker>> _markerStreamController = new StreamController();
  Stream<Set<Marker>> get markerStream => _markerStreamController.stream;

  void showMarkers(Set<Marker> markers){
    _markerStreamController.sink.add(markers);
  }

  void removeMarkers(){
    _markerStreamController.sink.add(new Set<Marker>());
  }

  void dispose(){
    _mapCameraStreamController.close();
    _markerStreamController.close();
  }
}