import 'package:flutter/material.dart';

class User {
  String uid;
  String displayName;
  String email;
  String imageUrl;
  AuthenticationMethod authenticationMethod;

  User({this.uid, this.displayName, this.email, this.imageUrl,
      this.authenticationMethod});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'displayName': this.displayName,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'authenticationMethod': (this.authenticationMethod??AuthenticationMethod.GOOGLE).toString(),
    };
  }


}

enum AuthenticationMethod{
  GOOGLE,
  EMAIL_AND_PASSWORD
}

