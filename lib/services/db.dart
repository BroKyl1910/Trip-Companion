import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripcompanion/models/user.dart';

abstract class DatabaseBase {
  Future<User> getUser(String uid);
  Future<User> insertUser(User user);
}

class FirestoreDatabase implements DatabaseBase{
  String uid;

  @override
  Future<User> getUser(String uid) async {
    return null;
  }

  @override
  Future<User> insertUser(User user) async {
    final path = "/users/${user.uid}";
    final documentReference = Firestore.instance.document(path);
    documentReference.setData(user.toMap());
    return null;
  }

}