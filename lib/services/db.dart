import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripcompanion/helpers/api_path.dart';
import 'package:tripcompanion/models/user.dart';

abstract class DatabaseBase {
  Future<User> getUser(String uid);
  Future<void> insertUser(User user);
}

class FirestoreDatabase implements DatabaseBase{
  String uid;

  @override
  Future<User> getUser(String uid) async {
    final path = APIPath.user(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    snapshots.listen((snapshot) {
      if(snapshot.documents.isEmpty){
        //Google User
        print('Google User');
      }
      snapshot.documents.forEach((snapshot) => print(snapshot.data));

    });

    return User();
  }

  @override
  Future<void> insertUser(User user) async => _setData(path: APIPath.user(user.uid), data: user.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final documentReference = Firestore.instance.document(path);
    print('$path: $data');
    await documentReference.setData(data);
  }



}