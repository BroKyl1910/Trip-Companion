import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripcompanion/helpers/shared_prefs_helper.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class DataPreloadBloc {
  StreamController<User> _userController = new BehaviorSubject();

  Stream<User> get userStream => _userController.stream;

  void getLoggedInUserDetails() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    User storedUser = await FirestoreDatabase().getUser(currentUser.uid);

    if (storedUser.authenticationMethod == AuthenticationMethod.GOOGLE) {
      bool exists = await FirestoreDatabase().userExists(storedUser.uid);
      if (!exists) {
        await FirestoreDatabase().insertUser(storedUser);
      }
    }

    SharedPrefsHelper.setUser(storedUser);

    _userController.sink.add(storedUser);
  }

  void dispose() {
    _userController.close();
  }
}
