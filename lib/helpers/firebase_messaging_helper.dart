import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tripcompanion/helpers/credentials.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingHelper {
  FirebaseMessaging _fcm;

  FirebaseMessagingHelper._privateConstructor() {
    _fcm = FirebaseMessaging();
  }

  static final FirebaseMessagingHelper _instance =
      FirebaseMessagingHelper._privateConstructor();

  static FirebaseMessagingHelper get instance => _instance;

  void configure({Function onMessage, Function onResume, Function onLaunch}) {
    _fcm.configure(
        onMessage: onMessage, onResume: onResume, onLaunch: onLaunch);
  }

  Future<String> getFcmToken() async {
    String token = await _fcm.getToken();
    return token;
  }

  Future<void> sendNotification(
      String title, String message, User recipient) async {
    String url = "https://fcm.googleapis.com/fcm/send";

    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Credentials.FIREBASE_SERVER_API_KEY}'
        },
        body: jsonEncode(<String, String>{
          'to': recipient.fcmToken,
          'notification: ': '{"body" : "$message", "title":"$title"}',
          'data': '{"title": "$title", "body":"$message","click_action":"FLUTTER_NOTIFICATION_CLICK"}'
        }));

    print(response);
  }
}