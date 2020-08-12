import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/event_user_view_model.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class EventsBloc{
  BehaviorSubject<List<Event>> _myEventsStreamController = new BehaviorSubject();
  Stream<List<Event>> get myEventsStream => _myEventsStreamController.stream;

  void getMyEvents(User currentUser) async {
    var events = await FirestoreDatabase().getEvents(currentUser.eventsOrganised);


    // Remove ones which have already passed
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now().subtract(Duration(days: 1))));

    // Sort by date
    events.sort((a, b)=> a.dateTime.compareTo(b.dateTime));

    _myEventsStreamController.sink.add(events);
  }

  BehaviorSubject<List<EventUserViewModel>> _attendingEventsStreamController = new BehaviorSubject();
  Stream<List<EventUserViewModel>> get attendingEventsStream => _attendingEventsStreamController.stream;

  void getAttendingEvents(User currentUser) async {
    List<EventUserViewModel> viewModels = new List<EventUserViewModel>();
    var eventUIDs = currentUser.eventsAttending;
    for(int i = 0; i < eventUIDs.length; i++){
      var event = await FirestoreDatabase().getEvent(eventUIDs[i]);
      if(!event.dateTime.isBefore(DateTime.now().subtract(Duration(days: 1)))){
        var organiser = await FirestoreDatabase().getUser(event.organiser);
        viewModels.add(EventUserViewModel(event: event, user: organiser));
      }
    }

    viewModels.sort((a, b)=> a.event.dateTime.compareTo(b.event.dateTime));

    _attendingEventsStreamController.sink.add(viewModels);
  }

  BehaviorSubject<List<EventUserViewModel>> _eventInvitesStreamController = new BehaviorSubject();
  Stream<List<EventUserViewModel>> get eventInvitesStream => _eventInvitesStreamController.stream;

  void getEventInvites(User currentUser) async {
    List<EventUserViewModel> viewModels = new List<EventUserViewModel>();
    var eventUIDs = currentUser.eventRequests;
    for(int i = 0; i < eventUIDs.length; i++){
      var event = await FirestoreDatabase().getEvent(eventUIDs[i]);
      if(!event.dateTime.isBefore(DateTime.now())){
        var organiser = await FirestoreDatabase().getUser(event.organiser);
        viewModels.add(EventUserViewModel(event: event, user: organiser));
      }
    }
    viewModels.sort((a, b)=> a.event.dateTime.compareTo(b.event.dateTime));

    _eventInvitesStreamController.sink.add(viewModels);

  }



  BehaviorSubject<bool> _refreshStreamController = new BehaviorSubject();
  Stream<bool> get refreshStream => _refreshStreamController.stream;

  void refresh(){
    _refreshStreamController.sink.add(true);
  }

  void dispose(){
    _myEventsStreamController.close();
    _attendingEventsStreamController.close();
    _eventInvitesStreamController.close();
    _refreshStreamController.close();
  }
}