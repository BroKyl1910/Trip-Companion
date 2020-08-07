import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class EventDetailsBloc{
  BehaviorSubject<User> _organiserStreamController = new BehaviorSubject<User>();
  Stream<User> get organiserStream => _organiserStreamController.stream;

  Future<void> getOrganiser(Event event) async{
    var organiser = await FirestoreDatabase().getUser(event.organiser);
    _organiserStreamController.sink.add(organiser);
  }

  BehaviorSubject<bool> _showAttendeesController = new BehaviorSubject();
  Stream<bool> get showAttendeesStream => _showAttendeesController.stream;

  void showAttendees(){
    _showAttendeesController.sink.add(true);
  }

  void hideAttendees(){
    _showAttendeesController.sink.add(false);
  }

  BehaviorSubject<List<User>> _attendeesController = new BehaviorSubject();
  Stream<List<User>> get attendeesStream => _attendeesController.stream;

  Future<void> getAttendees(Event event) async {
    List<User> attendees = new List<User>();
    for(int i = 0; i < event.attendees.length; i++){
      User attendee = await FirestoreDatabase().getUser(event.attendees[i]);
      attendees.add(attendee);
    }
    _attendeesController.sink.add(attendees);
  }

  BehaviorSubject<bool> _refreshController = new BehaviorSubject();
  Stream<bool> get refreshStream => _refreshController.stream;

  Future<void> refresh() async {
    _refreshController.sink.add(true);
  }


  void dispose(){
    _organiserStreamController.close();
    _attendeesController.close();
    _showAttendeesController.close();
    _refreshController.close();
  }
}