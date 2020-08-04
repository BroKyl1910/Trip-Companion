import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';

class CreateEventBloc{
  BehaviorSubject<DateTime> _dateController = new BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> _timeController = new BehaviorSubject<DateTime>();
  Stream<DateTime> get dateStream => _dateController.stream;
  Stream<DateTime> get timeStream => _timeController.stream;

  void addDate(DateTime dateTime){
    _dateController.sink.add(dateTime);
  }

  void addTime(DateTime dateTime){
    _timeController.sink.add(dateTime);
  }

  StreamController<bool> _showInviteFriendsController = new BehaviorSubject();
  Stream<bool> get showInviteFriendsStream => _showInviteFriendsController.stream;

  void showInviteFriends(){
    _showInviteFriendsController.sink.add(true);
  }

  void hideInviteFriends(){
    _showInviteFriendsController.sink.add(false);
  }

  BehaviorSubject<List<User>> _inviteFriendsController = new BehaviorSubject();
  Stream<List<User>> get inviteFriendsStream => _inviteFriendsController.stream;

  void inviteFriends(List<User> users){
    _inviteFriendsController.sink.add(users);
  }

  void saveEventToFirestore(Event event){

  }

  DateTime getLastDate(){
    return _dateController.value;
}

  DateTime getLastTime(){
    return _timeController.value;
  }

  List<User> getLastInvitedFriends(){
    return _inviteFriendsController.value;
  }


  void dispose(){
    _dateController.close();
    _timeController.close();
    _showInviteFriendsController.close();
    _inviteFriendsController.close();
  }
}