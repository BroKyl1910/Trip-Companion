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

  Future<User> registerWithEmailAndPassword(String name, String surname, String email, String password) async {
    try {
      _setIsLoading(true);
      await auth.registerWithEmailAndPassword(email, password);
      //String uid, String email, String imageUrl, String name, String surname
      User newUser = new EmailAndPasswordUser((await auth.currentUser()).uid, email, "", name, surname);
      User user = await db.insertUser(newUser);
      return user;
    } catch (e) {
      rethrow;
    }finally{
      _setIsLoading(false);
    }
  }
}
