import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';

class Invite{
  String id;
  User recipient;
  User sender;
  Event event;
  InviteStatus status;

  Invite({this.id, this.recipient, this.sender, this.event, this.status});
}

enum InviteStatus{
  PENDING,
  DECLINED,
  ACCEPTED
}