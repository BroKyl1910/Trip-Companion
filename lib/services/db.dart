import 'package:tripcompanion/models/user.dart';

abstract class DatabaseBase {
  Future<User> getUser(String uid);
  Future<String> insertUser(User user);
}

class Database implements DatabaseBase{
  @override
  Future<User> getUser(String uid) {
    // TODO: implement getUser
    return null;
  }

  @override
  Future<String> insertUser(User user) {
    // TODO: implement insertUser
    return null;
  }

}