import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class EditEventBloc{
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

  DateTime getLastDate(){
    return _dateController.value;
  }

  DateTime getLastTime(){
    return _timeController.value;
  }

  List<User> getLastInvitedFriends(){
    return _inviteFriendsController.value;
  }

  BehaviorSubject<List<User>> _uninvitedFriendsController = new BehaviorSubject();
  Stream<List<User>> get uninvitedFriendsStream => _uninvitedFriendsController.stream;

  Future<void> getUninvitedFriends(User user, Event event) async{
    var friends = user.friends;
    var invitees = event.invited;
    var attendees = event.attendees;

    List<User> uninvited = new List<User>();
    for(int i = 0; i < friends.length; i ++){
      var friend = friends[i];
      if(!invitees.contains(friend) && !attendees.contains(friend)){
        uninvited.add(await FirestoreDatabase().getUser(friend));
      }
    }

    _uninvitedFriendsController.sink.add(uninvited);
  }
  void dispose(){
    _dateController.close();
    _timeController.close();
    _showInviteFriendsController.close();
    _inviteFriendsController.close();
    _uninvitedFriendsController.close();
  }


}