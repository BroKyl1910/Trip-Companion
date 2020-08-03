import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/user.dart';

class CreateEventBloc{
  StreamController<DateTime> _dateController = new BehaviorSubject<DateTime>();
  StreamController<DateTime> _timeController = new BehaviorSubject<DateTime>();
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

  StreamController<List<String>> _inviteFriendsController = new BehaviorSubject();
  Stream<List<String>> get inviteFriendsStream => _inviteFriendsController.stream;

  void inviteFriends(List<String> uids){
    _inviteFriendsController.sink.add(uids);
  }

  void dispose(){
    _dateController.close();
    _timeController.close();
    _showInviteFriendsController.close();
    _inviteFriendsController.close();
  }
}