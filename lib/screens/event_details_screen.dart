import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';

enum EventStatus { ORGANISER, INVITED, ATTENDING }

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen(this.event);

  Widget _buildTopBar(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    Widget child;
    if (currentUser.eventsOrganised.contains(event.uid)) {
      child = _buildTopBarOrganiser(context, currentUser);
    } else if (currentUser.eventRequests.contains(event.uid)) {
      child = _buildTopBarInvited(context, currentUser);
    } else {
      child = _buildTopBarAttending(context, currentUser);
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[400], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          child,
        ],
      ),
    );
  }

  Widget _buildTopBarOrganiser(BuildContext context, User user) {
    return Container();
  }

  Widget _buildTopBarInvited(BuildContext context, User user) {
    return Container();
  }

  Widget _buildTopBarAttending(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'You are attending',
            style: TextStyle(color: Colors.white),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[500]
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  ),
                  Text('I can\'t attend',
                  style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
                                    var mapBloc =
                                        Provider.of<MapControllerBloc>(context,
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
                                "Event Details",
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(6),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  // Respond or admin
//                                  _buildTopBar(context),
//                                  SizedBox(
//                                    height: 10,
//                                  ),
                                  // Venue
                                  Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: (){
                                        print('Tap');
                                      },
                                      splashColor: Color.fromARGB(125, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        height: 50,
                                        child: Row(
                                          children: <Widget>[

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Date
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Time
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Name
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Description
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Attendees
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
//        StreamBuilder<bool>(
//          stream: Provider.of<CreateEventBloc>(context, listen: false)
//              .showInviteFriendsStream,
//          initialData: false,
//          builder: (context, snapshot) {
//            if (snapshot.data == false) {
//              return Container();
//            }
//            return _showInviteFriendsDialog(context);
//          },
//        )
      ],
    );
  }
}
