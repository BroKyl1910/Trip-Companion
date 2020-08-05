import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/db.dart';

class RegisterBloc {
  final AuthBase auth;
  final DatabaseBase db;

  RegisterBloc({@required this.auth, @required this.db});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool val) => _isLoadingController.add(val);

  Future<void> registerWithEmailAndPassword(
      String name, String surname, String email, String password) async {
    try {
      _setIsLoading(true);
      User user = await auth.registerWithEmailAndPassword(email, password);
      User newUser = new User(
        uid: user.uid,
        authenticationMethod: AuthenticationMethod.EMAIL_AND_PASSWORD,
        email: email,
        displayName: "$name $surname",
        imageUrl: "",
        friends: new List<String>(),
        incomingFriendRequests: new List<String>(),
        outgoingFriendRequests: new List<String>(),
        eventsOrganised: new List<String>(),
        eventRequests: new List<String>(),
        eventsAttending: new List<String>(),
      );
      await db.insertUser(newUser);
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }
}
