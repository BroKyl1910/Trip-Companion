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

  void dispose(){
    _usersStreamController.close();
  }
}