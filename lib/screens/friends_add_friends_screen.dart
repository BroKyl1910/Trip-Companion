import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/helpers/shared_prefs_helper.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/screens/friends_main_screen.dart';
import 'package:tripcompanion/services/db.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';

class AddFriendsScreen extends StatelessWidget {
  final TextEditingController _searchTextController = TextEditingController();

  onTextChanged(String val, BuildContext context, FriendsBloc bloc) {
    bloc.searchUsers(val);
  }

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
    return Padding(
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

    switch (friendStatus) {
      case FriendStatus.FRIENDS:
        iconData = Icons.check;
        caption = 'Friends';
        onPressed = _handleDeleteFriend;
        break;
      case FriendStatus.PENDING:
        iconData = Icons.person_outline;
        caption = 'Request sent';
        onPressed = _handleDeleteFriendRequest;
        break;
      case FriendStatus.NOT_FRIENDS:
        iconData = Icons.person_add;
        caption = 'Add Friend';
        onPressed = _handleAddFriend;
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          icon: Icon(iconData),
          iconSize: 20.0,
          onPressed: () async {
            await onPressed.call(currentUser, user);
            Provider.of<FriendsBloc>(context, listen: false).refresh();
          },
        ),
      ),
    );
  }

  _handleAddFriend(User currentUser, User recipient) async {
    // If recipient already sent currentUser a request, just add as friend
    if (currentUser.incomingFriendRequests.contains(recipient.uid)) {
      currentUser.friends.add(recipient.uid);
      recipient.friends.add(currentUser.uid);

      currentUser.incomingFriendRequests.remove(recipient.uid);
      recipient.outgoingFriendRequests.remove(currentUser.uid);
    } else {
      currentUser.outgoingFriendRequests.add(recipient.uid);
      recipient.incomingFriendRequests.add(currentUser.uid);
    }

    await FirestoreDatabase().insertUser(currentUser);
    await FirestoreDatabase().insertUser(recipient);
  }

  _handleDeleteFriend(User currentUser, User recipient) async {
    // Delete friend from current user
    currentUser.friends.remove(recipient.uid);
    //Delete friend on recipient
    recipient.friends.remove(currentUser.uid);
    await FirestoreDatabase().insertUser(currentUser);
    await FirestoreDatabase().insertUser(recipient);
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
    var friendsBloc = Provider.of<FriendsBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                hintText: 'Search by display name or email',
                border: InputBorder.none,
              ),
              controller: _searchTextController,
              onChanged: (val) => onTextChanged(val, context, friendsBloc)),
          SizedBox(height: 20),
          StreamBuilder<List<User>>(
              stream: friendsBloc.userStream,
              builder: (context, friendsSnapshot) {
                return StreamBuilder<bool>(
                    stream: friendsBloc.refreshStream,
                    builder: (context, snapshot) {
                      if (_searchTextController.text.isEmpty)
                        return Container();
                      return _buildListView(context, friendsSnapshot);
                    });
              })
        ],
      ),
    );
  }
}
