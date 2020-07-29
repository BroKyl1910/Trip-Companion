import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/models/user.dart';

class AddFriendsScreen extends StatelessWidget {
  final TextEditingController _searchTextController = TextEditingController();

  onTextChanged(String val, BuildContext context, FriendsBloc bloc) {
    bloc.searchUsers(val);
  }

  _search(BuildContext context) {}

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
              (user.imageUrl == null || user.imageUrl.isEmpty)?
              Container(
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
              :
              Container(
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
          SizedBox(width: 5,),
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
                      user.email,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                icon: Icon(Icons.person_add),
                iconSize: 20.0,
                onPressed: () {

                },
              ),
            ),
          )
        ],
      ),
    );
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
            onChanged: (val) => onTextChanged(val, context, friendsBloc),
            onEditingComplete: () => _search(context),
          ),
          SizedBox(height: 20),
          StreamBuilder<List<User>>(
              stream: friendsBloc.userStream,
              builder: (context, snapshot) {
                return _buildListView(context, snapshot);
              })
        ],
      ),
    );
  }
}
