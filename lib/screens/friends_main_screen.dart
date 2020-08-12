import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/data_preload_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/screens/friends_friend_requests_screen.dart';
import 'package:tripcompanion/screens/friends_my_friends_screen.dart';

import 'friends_add_friends_screen.dart';

class FriendsMainScreen extends StatefulWidget {
  @override
  _FriendsMainScreenState createState() => new _FriendsMainScreenState();
}

class _FriendsMainScreenState extends State<FriendsMainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    Provider.of<DataPreloadBloc>(context, listen: false).refreshUser();
  }

  Widget _buildFriendsTabController() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(120, 0, 0, 0),
              offset: Offset(2.0, 2.0),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              // Tab headers
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white),
              child: new TabBar(
                controller: _controller,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  new Tab(
                    icon: const Icon(Icons.group_add),
                    text: 'Add Friends',
                  ),
                  new Tab(
                    icon: const Icon(Icons.people),
                    text: 'My Friends',
                  ),
                  new Tab(
                    icon: const Icon(Icons.person_outline),
                    text: 'Friend Requests',
                  ),
                ],
              ),
            ),
            Expanded(
              child: new TabBarView(
                controller: _controller,
                children: <Widget>[
                  AddFriendsScreen(),
                  MyFriendsScreen(),
                  FriendRequestsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            //Top bar
            Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(120, 0, 0, 0),
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Material(
                            type: MaterialType.transparency,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 20.0,
                              onPressed: () {
                                var navBloc = Provider.of<NavigationBloc>(
                                    context,
                                    listen: false);
                                var mapBloc = Provider.of<MapControllerBloc>(
                                    context,
                                    listen: false);
                                mapBloc.removeMarkers();
                                navBloc.back();
                              },
                              splashColor: Color.fromARGB(130, 0, 0, 0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Friends",
                            style: Theme.of(context).textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            _buildFriendsTabController(),
          ],
        ),
      ),
    );
  }
}

enum FriendStatus { NOT_FRIENDS, PENDING, FRIENDS }
