import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripcompanion/models/user.dart';

class Event{
  String uid;
  String organiser;
  DateTime dateTime;
  String placeId;
  String venueName;
  String eventTitle;
  String description;
  List<String> attendees;
  List<String> invited;

  Event({this.uid, this.organiser, this.dateTime, this.placeId, this.venueName, this.eventTitle, this.description, this.attendees, this.invited});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'organiser': this.organiser,
      'dateTime': this.dateTime,
      'placeId': this.placeId,
      'venueName': this.venueName,
      'eventTitle': this.eventTitle,
      'description': this.description,
      'attendees': this.attendees??new List<String>(),
      'invited': this.invited??new List<String>(),
    };
  }

  Event fromMap(Map<String, dynamic> data){
    return Event(
      uid: data["uid"],
      organiser: data["organiser"],
      dateTime: cast<Timestamp>(data["dateTime"]).toDate(),
      placeId: data["placeId"],
      venueName: data["venueName"],
      eventTitle: data["eventTitle"],
      description: data["description"],
      attendees: getListOfStrings(data["attendees"]),
      invited: getListOfStrings(data["invited"]),
    );
  }

  List<String> getListOfStrings(List<dynamic> data) {
    List<String> returnStrings = new List<String>();
    if(data == null) return returnStrings;
    for(int i = 0; i < data.length; i++){
      returnStrings.add(data[i].toString());
    }

    return returnStrings;
  }

  String latLngToString(LatLng location) {
    return '${location.latitude},${location.longitude}';
  }

  LatLng stringToLatLng(String data) {
    var dataParts = data.split(',');
    return LatLng(double.parse(dataParts[0]), double.parse(dataParts[1]));
  }

  T cast<T>(x) => x is T ? x : null;
}
