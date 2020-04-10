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

  User fromMap(Map<String, dynamic> data){
    return User(
      uid: data["uid"],
      displayName: data["displayName"],
      email: data["email"],
      imageUrl: data["imageUrl"],
      authenticationMethod: (data["authenticationMethod"]).toString().split('.')[1] == "GOOGLE" ? AuthenticationMethod.GOOGLE : AuthenticationMethod.EMAIL_AND_PASSWORD,
    );
  }


}

enum AuthenticationMethod{
  GOOGLE,
  EMAIL_AND_PASSWORD
}

