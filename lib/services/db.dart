import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripcompanion/helpers/firestore_path.dart';
import 'package:tripcompanion/helpers/shared_prefs_helper.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';

abstract class DatabaseBase {
  Future<User> getUser(String uid);

  Future<void> insertUser(User user);
}

class FirestoreDatabase implements DatabaseBase {
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

      print('Exists in database');
      Map<String, dynamic> data = document.data;
      user = User().fromMap(data);
      return user;
    } else {
      //Google User

      print('Doesn\'t exist');
      user.authenticationMethod = AuthenticationMethod.GOOGLE;
      var u = await FirebaseAuth.instance.currentUser();

      user.displayName = u.displayName;
      user.email = u.email;
      user.imageUrl = u.photoUrl;
      user.uid = u.uid;

      return user;
    }
  }

  Future<List<User>> getUsers(List<String> uids) async{
    List<User> users = new List<User>();
    for(int i = 0; i < uids.length; i++){
      users.add(await getUser(uids[i]));
    }
    return users;
  }

  Future<Event> getEvent(String uid) async {
    Event event = Event();

    var document =
    await Firestore.instance.collection('events').document(uid).get();

    if (document.exists) {

      Map<String, dynamic> data = document.data;
      event = Event().fromMap(data);
    } else{
      event = null;
    }

    return event;

  }

  Future<List<Event>> getEvents(List<String> uids) async{
    List<Event> events = new List<Event>();
    for(int i = 0; i < uids.length; i++){
      events.add(await getEvent(uids[i]));
    }
    return events;
  }


  Future<void> insertEvent(Event event) async{
    _setData(path: FirestorePath.event(event.uid), data: event.toMap());
  }

  Future<void> deleteEvent(Event event) async{
    final documentReference = Firestore.instance.collection('events').document(event.uid);
    await documentReference.delete();
  }

  @override
  Future<void> insertUser(User user) async =>
      _setData(path: FirestorePath.user(user.uid), data: user.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final documentReference = Firestore.instance.document(path);
    print('$path: $data');
    await documentReference.setData(data);
  }

  Future<List<User>> searchUsers(String query) async {
    List<User> users = new List<User>();
    User currentUser = await SharedPrefsHelper.getUser();
    var userDocuments = (await Firestore.instance.collection('users').getDocuments()).documents;

    for(int i = 0; i < userDocuments.length; i++){
      User u = User().fromMap(userDocuments[i].data);
      if((u.email.toLowerCase().contains(query.toLowerCase()) || u.displayName.toLowerCase().contains(query.toLowerCase())) && u != currentUser){
        users.add(u);
      }
    }

    return users;
  }
}
