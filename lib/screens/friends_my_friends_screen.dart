import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/models/user.dart';

class MyFriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var friendsBloc = Provider.of<FriendsBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          StreamBuilder<List<User>>(
              stream: friendsBloc.myFriendsStream,
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
