import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tripcompanion/helpers/exceptions.dart';
import 'package:tripcompanion/models/user.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<AuthenticationMethod> getCurrentUserAuthenticationMethod();

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

    User user = new User();
    try {
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      user = _userFromFirebaseUser(authResult.user);
    } catch (e) {
      return Future.error(
          ExceptionAdapter().firebaseToAuthenticationException(e));
    }

    return user;
  }

  @override
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    User user = User();
    try{
      final AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = _userFromFirebaseUser(authResult.user);
    }
    catch(e){
      return Future.error(ExceptionAdapter().firebaseToAuthenticationException(e));
    }
    return user;

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

@override
  Future<AuthenticationMethod> getCurrentUserAuthenticationMethod() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    String displayName = currentUser.displayName;
    if(displayName == null){
      return AuthenticationMethod.EMAIL_AND_PASSWORD;
    }
    return AuthenticationMethod.GOOGLE;
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  
}