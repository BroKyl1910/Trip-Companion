import 'package:flutter/material.dart';

abstract class User {
  final String uid;
  final String email;
  final String imageUrl;
  final AuthenticationMethod authenticationMethod;

  User({this.uid, this.email, this.imageUrl, this.authenticationMethod});

  Map<String, dynamic> toMap();
}

class EmailAndPasswordUser extends User {

  final String name;
  final String surname;

  EmailAndPasswordUser(String uid, String email, String imageUrl, String name, String surname):
      this.name = name,
      this.surname = surname,
      super(uid: uid, email: email, imageUrl: imageUrl, authenticationMethod: AuthenticationMethod.EMAIL_AND_PASSWORD);

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'surname': this.surname,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'authenticationMethod': this.authenticationMethod,

    };
  }

}

class GoogleUser extends User {

  final String displayName;

  GoogleUser(String uid, String email, String imageUrl, String displayName):
        this.displayName = displayName,
        super(uid: uid, email: email, imageUrl: imageUrl, authenticationMethod: AuthenticationMethod.GOOGLE);

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'displayName': this.displayName,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'authenticationMethod': this.authenticationMethod,

    };
  }

}

enum AuthenticationMethod{
  GOOGLE,
  EMAIL_AND_PASSWORD
}

