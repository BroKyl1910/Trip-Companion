import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationBase{}

class GeoLocatorLocation implements LocationBase{

  Future<LatLng> getCurrentPosition() async{
    Position position =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _geoLocatorToLatLng(position);
  }

  LatLng _geoLocatorToLatLng(Position position){
    return LatLng(position.latitude, position.longitude);
  }
}