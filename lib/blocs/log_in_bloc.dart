import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';

class LogInBloc {
  final AuthBase auth;

  LogInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool val) => _isLoadingController.add(val);

  Future<User> signInWithGoogle() async {
    try {
      _setIsLoading(true);
      return await auth.signInWithGoogle();
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setIsLoading(true);
      return await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }
}
