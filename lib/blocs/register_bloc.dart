import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';

class RegisterBloc {
  final AuthBase auth;

  RegisterBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool val) => _isLoadingController.add(val);

  Future<User> registerWithEmailAndPassword(String email, String password) async {
    try {
      _setIsLoading(true);
      await auth.registerWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    }finally{
      _setIsLoading(false);
    }
  }
}
