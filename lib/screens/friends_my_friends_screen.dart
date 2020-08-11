import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/helpers/alert_dialog_helper.dart';
import 'package:tripcompanion/helpers/firebase_messaging_helper.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

import 'friends_main_screen.dart';

class MyFriendsScreen extends StatelessWidget {
  Widget _buildListView(
      BuildContext context, AsyncSnapshot<List<User>> snapshot) {
    if (!snapshot.hasData || snapshot.data.length == 0)
      return Container(
        height: 0,
        width: 0,
      );
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext ctx, int index) {
            return _buildFriend(ctx, snapshot.data[index]);
          }),
    );
  }

  Widget _buildFriend(BuildContext context, User user) {
    return GestureDetector(
      onTap: ()async{
        Provider.of<FirebaseMessagingHelper>(context, listen: false).sendNotification('Test', 'Hey', user);
        print('send notif');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                (user.imageUrl == null || user.imageUrl.isEmpty)
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red[600],
                            ),
                            color: Colors.red),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              user.displayName[0].toUpperCase(),
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (context, url, progress) =>
                                CircularProgressIndicator(
                              value: progress.progress,
                            ),
                            imageUrl: user.imageUrl,
                          ),
                        ),
                      ),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        user.displayName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        user.email,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color.fromARGB(120, 0, 0, 0), fontSize: 14),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                _buildAddFriendButton(context, user),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildAddFriendButton(BuildContext context, User user) {
    User currentUser = Provider.of<User>(context, listen: false);
    FriendStatus friendStatus;

    // Pending shows when current user has sent user a friend request
    // If current user has a friend request from user, not friends will show
    if (currentUser.friends == null) {
      friendStatus = FriendStatus.NOT_FRIENDS;
    } else if (currentUser.friends.contains(user.uid)) {
      friendStatus = FriendStatus.FRIENDS;
    } else if (currentUser.outgoingFriendRequests.contains(user.uid)) {
      friendStatus = FriendStatus.PENDING;
    } else {
      friendStatus = FriendStatus.NOT_FRIENDS;
    }

    IconData iconData;
    String caption;
    Function onPressed;

    iconData = Icons.check;
    caption = 'Friends';
    onPressed = _handleDeleteFriend;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          icon: Icon(iconData),
          iconSize: 20.0,
          onPressed: () async {
            await onPressed.call(context, currentUser, user);
            Provider.of<FriendsBloc>(context, listen: false)
                .getMyFriends(currentUser);
          },
        ),
      ),
    );
  }

  _handleDeleteFriend(
      BuildContext context, User currentUser, User recipient) async {
    await AlertDialogHelper.showConfirmationDialog(context,
        'Are you sure you want to remove ${recipient.displayName} from your friends?',
        () async {
      // Delete friend from current user
      currentUser.friends.remove(recipient.uid);
      //Delete friend on recipient
      recipient.friends.remove(currentUser.uid);
      await FirestoreDatabase().insertUser(currentUser);
      await FirestoreDatabase().insertUser(recipient);
    });
  }

  _handleDeleteFriendRequest(User currentUser, User recipient) async {
    // Delete outgoing friend request from current user
    currentUser.outgoingFriendRequests.remove(recipient.uid);
    //Delete incoming on recipient
    recipient.incomingFriendRequests.remove(currentUser.uid);
    await FirestoreDatabase().insertUser(currentUser);
    await FirestoreDatabase().insertUser(recipient);
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    var friendsBloc = Provider.of<FriendsBloc>(context, listen: false);
    friendsBloc.getMyFriends(currentUser);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<User>>(
                stream: friendsBloc.myFriendsStream,
                builder: (context, friendsSnapshot) {
                  return StreamBuilder<bool>(
                      stream: friendsBloc.refreshStream,
                      builder: (context, refreshSnapshot) {
                        if (!friendsSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (friendsSnapshot.data.length > 0) {
                          return _buildListView(context, friendsSnapshot);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Send some friend requests to get started!',
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          );
                        }
                      });
                }),
          )
        ],
      ),
    );
  }
}
