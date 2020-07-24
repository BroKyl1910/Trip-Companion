import 'dart:async';

import 'package:flutter/foundation.dart';
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
      await auth.signInWithGoogle();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    } finally {
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setIsLoading(true);
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }
}
