import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/create_event_bloc.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/models/user.dart';

class InviteFriendsCreateWidget extends StatefulWidget {
  @override
  _InviteFriendsCreateWidgetState createState() => _InviteFriendsCreateWidgetState();

  final Function handleCloseDialog;
  final Function handleSaveList;

  InviteFriendsCreateWidget({this.handleCloseDialog, this.handleSaveList});
}

class _InviteFriendsCreateWidgetState extends State<InviteFriendsCreateWidget> {
  static List<User> _selectedFriends;

  Widget _buildListView(
      BuildContext context, List<User> friends) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: friends.length,
        itemBuilder: (BuildContext ctx, int index) {
          return _buildFriend(
              ctx,
              friends[index],
              Provider.of<CreateEventBloc>(context, listen: false));
        });
  }

  _toggleSelected(User friend, CreateEventBloc bloc) {
    setState(() {
      if (_selectedFriends.contains(friend)) {
        _selectedFriends.remove(friend);
      } else {
        _selectedFriends.add(friend);
      }
    });

  }

  Widget _buildFriend(BuildContext context, User friend, CreateEventBloc bloc) {
    bool invited = _selectedFriends.contains(friend);
    return GestureDetector(
      onTap: () {
        _toggleSelected(friend, bloc);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: invited ? Color.fromARGB(125, 66, 165, 245) : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    (friend.imageUrl == null || friend.imageUrl.isEmpty)
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
                                  friend.displayName[0].toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) =>
                                        CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                                imageUrl: friend.imageUrl,
                              ),
                            ),
                          ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
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
                            friend.displayName,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            friend.email,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color.fromARGB(120, 0, 0, 0),
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSelectedFriendsToBloc() {
    var createEventBloc = Provider.of<CreateEventBloc>(context, listen: false);
    createEventBloc.inviteFriends(_selectedFriends);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    var friendsBloc = Provider.of<FriendsBloc>(context, listen: false);
    var createEventBloc = Provider.of<CreateEventBloc>(context, listen: false);

    friendsBloc.getMyFriends(user);

    if (_selectedFriends == null) _selectedFriends = new List<User>();

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(120, 0, 0, 0),
            offset: Offset(2.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                //Top bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Invite Friends',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          iconSize: 20.0,
                                          color: Colors.white,
                                          onPressed: () {
                                            _saveSelectedFriendsToBloc();
                                            widget.handleCloseDialog(context);
                                          },
                                          splashColor:
                                              Color.fromARGB(130, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: IconButton(
                                          icon: Icon(Icons.check),
                                          iconSize: 20.0,
                                          color: Colors.white,
                                          onPressed: () {
                                            _saveSelectedFriendsToBloc();
                                            widget.handleSaveList(context);
                                          },
                                          splashColor:
                                              Color.fromARGB(130, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<List<User>>(
                          stream: friendsBloc.myFriendsStream,
                          builder: (context, myFriendsSnapshot) {
                            if (myFriendsSnapshot.hasData) {
                              var friends = myFriendsSnapshot.data;
                              return StreamBuilder<List<User>>(
                                  stream: createEventBloc.inviteFriendsStream,
                                  initialData: new List<User>(),
                                  builder: (context, invitedFriendsSnapshot) {
                                    _selectedFriends = invitedFriendsSnapshot.data;
                                    return _buildListView(context, friends);
                                  });
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
