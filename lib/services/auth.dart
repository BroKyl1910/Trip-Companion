import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInWithGoogle();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> registerWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((u) => _userFromFirebaseUser(u));
  }

  @override
  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebaseUser(user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    User user;
    try {
      final AuthResult authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = _userFromFirebaseUser(authResult.user);
    } catch (e) {
      return Future.error(
          ExceptionAdapter().firebaseToAuthenticationException(e));
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }
}

class ExceptionAdapter {
  AuthenticationException firebaseToAuthenticationException(dynamic e) {
    AuthenticationExceptionType type = AuthenticationExceptionType.UNKNOWN;
    String message = "Something went wrong";
    PlatformException ex = e as PlatformException;

    switch (ex.code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_WRONG_PASSWORD":
      case "ERROR_USER_NOT_FOUND":
        message = "Incorrect username or password";
        type = AuthenticationExceptionType.INCORRECT_CREDENTIALS;
        break;
      case "ERROR_NETWORK_REQUEST_FAILED":
        message = "Network error has occured";
        type = AuthenticationExceptionType.NETWORK_ERROR;
        break;
      case "ERROR_USER_DISABLED":
        message = "Account has been disabled";
        type = AuthenticationExceptionType.ACCOUNT_DISABLED;
        break;
      case "error":
        //As far as I can see, general error means empty string
        message = "Please fill in all fields";
        type = AuthenticationExceptionType.NULL_VALUE;
        break;
    }
    return AuthenticationException(message: message, type: type);
  }
}

class AuthenticationException implements Exception {
  final String message;
  final AuthenticationExceptionType type;

  AuthenticationException({this.message, this.type});
}

enum AuthenticationExceptionType {
  ACCOUNT_DISABLED,
  INCORRECT_CREDENTIALS,
  NETWORK_ERROR,
  NULL_VALUE,
  UNKNOWN
}
