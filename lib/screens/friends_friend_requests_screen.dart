import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

import 'friends_main_screen.dart';

class FriendRequestsScreen extends StatelessWidget {
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
              _buildResponseButtons(context, user),
            ],
          ),
        ],
      ),
    );
  }

  _buildResponseButtons(BuildContext context, User user) {
    User currentUser = Provider.of<User>(context, listen: false);

    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.close),
              iconSize: 20.0,
              onPressed: () async {
                await _handleDeleteFriendRequest(context, currentUser, user);
              },
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.check),
              iconSize: 20.0,
              onPressed: () async {
                await _handleAddFriend(context, currentUser, user);
              },
            ),
          ),
        )
      ],
    );
  }

  _handleAddFriend(BuildContext context, User currentUser, User recipient) async {
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

    Provider.of<FriendsBloc>(context, listen: false).getFriendRequests(currentUser);

  }


  _handleDeleteFriendRequest(BuildContext context, User currentUser, User recipient) async {
    // Delete outgoing friend request from current user
    currentUser.incomingFriendRequests.remove(recipient.uid);
    //Delete incoming on recipient
    recipient.outgoingFriendRequests.remove(currentUser.uid);
    await FirestoreDatabase().insertUser(currentUser);
    await FirestoreDatabase().insertUser(recipient);

    Provider.of<FriendsBloc>(context, listen: false).getFriendRequests(currentUser);

  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    var friendsBloc = Provider.of<FriendsBloc>(context, listen: false);
    friendsBloc.getFriendRequests(currentUser);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<bool>(
                stream: friendsBloc.refreshStream,
                builder: (context, refreshSnapshot) {
                  return StreamBuilder<List<User>>(
                      stream: friendsBloc.myFriendRequestsStream,
                      builder: (context, friendRequestsSnapshot) {

                        if(!friendRequestsSnapshot.hasData){
                          return Center(child: CircularProgressIndicator(),);
                        }

                        if (friendRequestsSnapshot.data.length > 0) {
                          return _buildListView(context, friendRequestsSnapshot);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'You have no new friend requests',
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
