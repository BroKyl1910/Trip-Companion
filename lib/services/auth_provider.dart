import 'package:flutter/material.dart';

import 'auth.dart';

class AuthProvider extends InheritedWidget{

  final AuthBase auth;
  final Widget child;
  AuthProvider({@required this.auth, @required this.child}):super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)  => false;

  static AuthBase of(BuildContext context){
    AuthProvider provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider.auth;
  }
}