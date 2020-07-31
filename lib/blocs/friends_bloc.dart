import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class FriendsBloc{
  StreamController<List<User>> _usersStreamController = new BehaviorSubject();
  Stream<List<User>> get userStream => _usersStreamController.stream;

  void searchUsers(String query) async {
    if(query.isEmpty){
      _usersStreamController.sink.add(new List<User>());
      return;
    }

    var users = await FirestoreDatabase().searchUsers(query);
    _usersStreamController.sink.add(users);
  }

  StreamController<List<User>> _myFriendsStreamController = new BehaviorSubject();
  Stream<List<User>> get myFriendsStream => _myFriendsStreamController.stream;

  void getMyFriends(User currentUser) async {
    var friends = await FirestoreDatabase().getUsers(currentUser.friends);
  }

  StreamController<bool> _refreshStreamController = new BehaviorSubject();
  Stream<bool> get refreshStream => _refreshStreamController.stream;

  void refresh(){
    _refreshStreamController.sink.add(true);
  }

  void dispose(){
    _usersStreamController.close();
    _myFriendsStreamController.close();
    _refreshStreamController.close();
  }
}