import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripcompanion/models/user.dart';

class SharedPrefsHelper{
  static Future<void> setUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', json.encode(user.toMap()));
    return;
  }

  static Future<User> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonUser = await sharedPreferences.get('user');
    User user = User().fromMap(json.decode(jsonUser));
    return user;
  }
}