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

  void dispose(){
    _organiserStreamController.close();
  }
}