import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripcompanion/models/user.dart';

class Event{
  String id;
  User organiser;
  DateTime dateTime;
  LatLng location;
  List<User> attendees;
  List<User> invited;

  Event({this.id, this.organiser, this.dateTime, this.location, this.attendees, this.invited});
}