import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/screens/events_attending_screen.dart';
import 'package:tripcompanion/screens/events_event_invitations_screen.dart';
import 'package:tripcompanion/screens/events_my_events_screen.dart';

class EventsMainScreen extends StatefulWidget {
  @override
  _EventsMainScreenState createState() => new _EventsMainScreenState();
}

class _EventsMainScreenState extends State<EventsMainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  Widget _buildEventsTabController() {
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
                    icon: const Icon(Icons.person),
                    text: 'My Events',
                  ),
                  new Tab(
                    icon: const Icon(Icons.event_available),
                    text: 'Attending',
                  ),
                  new Tab(
                    icon: const Icon(Icons.access_time),
                    text: 'Event Invitations',
                  ),
                ],
              ),
            ),
            Expanded(
              child: new TabBarView(
                controller: _controller,
                children: <Widget>[
                  MyEventsScreen(),
                  EventsAttendingScreen(),
                  EventInvitationsScreen(),
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
                                navBloc.navigate(Navigation.HOME);
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
                            "Events",
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
            _buildEventsTabController(),
          ],
        ),
      ),
    );
  }
}

