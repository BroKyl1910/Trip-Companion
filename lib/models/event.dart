import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripcompanion/models/user.dart';

class Event{
  String id;
  String organiser;
  DateTime dateTime;
  LatLng location;
  String description;
  List<String> attendees;
  List<String> invited;

  Event({this.id, this.organiser, this.dateTime, this.location, this.attendees, this.invited});
}
