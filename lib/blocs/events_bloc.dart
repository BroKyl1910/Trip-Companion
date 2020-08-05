import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class EventsBloc{
  BehaviorSubject<List<Event>> _myEventsStreamController = new BehaviorSubject();
  Stream<List<Event>> get myEventsStream => _myEventsStreamController.stream;

  void getMyEvents(User currentUser) async {
    var events = await FirestoreDatabase().getEvents(currentUser.eventsOrganised);
    _myEventsStreamController.sink.add(events);
  }

  BehaviorSubject<bool> _refreshStreamController = new BehaviorSubject();
  Stream<bool> get refreshStream => _refreshStreamController.stream;

  void refresh(){
    _refreshStreamController.sink.add(true);
  }

  void dispose(){
    _myEventsStreamController.close();
    _refreshStreamController.close();
  }
}