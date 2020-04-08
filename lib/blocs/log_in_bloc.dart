import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/db.dart';

class LogInBloc {
  final AuthBase auth;
  final DatabaseBase db;
  LogInBloc({@required this.auth, @required this.db});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool val) => _isLoadingController.add(val);

  Future<void> signInWithGoogle() async {
    try {
      _setIsLoading(true);
      bool isNewUser =  await auth.signInWithGoogle();
      if(isNewUser) db.insertUser(await auth.currentUser());
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setIsLoading(true);
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }
}
