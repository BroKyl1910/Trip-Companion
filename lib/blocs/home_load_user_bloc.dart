import 'dart:async';

import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/db.dart';

class GetUserBloc {
  final AuthBase auth;
  final DatabaseBase db;

  GetUserBloc({this.auth, this.db});

  StreamController<User> _userStreamController = new StreamController();
  Stream<User> get userStream => _userStreamController.stream;

  Future<void> getCurrentUser() async{
    final currentUserUid = (await auth.currentUser()).uid;
    User user = await db.getUser(currentUserUid);
    _userStreamController.sink.add(user);
  }


  void dispose(){
    _userStreamController.close();
  }
}