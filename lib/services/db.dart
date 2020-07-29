import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripcompanion/helpers/firestore_path.dart';
import 'package:tripcompanion/models/user.dart';

abstract class DatabaseBase {
  Future<User> getUser(String uid);

  Future<void> insertUser(User user);
}

class FirestoreDatabase implements DatabaseBase {
  String uid;

  Future<bool> userExists(String uid) async {
    var document =
        await Firestore.instance.collection('users').document(uid).get();
    return document.exists;
  }

  @override
  Future<User> getUser(String uid) async {
    User user = User();

    var document =
        await Firestore.instance.collection('users').document(uid).get();

    if (document.exists) {
      //Email user

      print('Email User');
      Map<String, dynamic> data = document.data;
      user = User().fromMap(data);
      return user;
    } else {
      //Google User

      print('Google User');
      user.authenticationMethod = AuthenticationMethod.GOOGLE;
      var u = await FirebaseAuth.instance.currentUser();

      user.displayName = u.displayName;
      user.email = u.email;
      user.imageUrl = u.photoUrl;
      user.uid = u.uid;

      return user;
    }
  }

  @override
  Future<void> insertUser(User user) async =>
      _setData(path: FirestorePath.user(user.uid), data: user.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final documentReference = Firestore.instance.document(path);
    print('$path: $data');
    await documentReference.setData(data);
  }
}
