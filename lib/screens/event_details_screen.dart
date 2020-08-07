import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/event_details_bloc.dart';
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
            decoration: BoxDecoration(color: Colors.blue[500]),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  ),
                  Text(
                    'I can\'t attend',
                    style: TextStyle(color: Colors.white),
                  )
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
    var detailsBloc = Provider.of<EventDetailsBloc>(context, listen: false);
    detailsBloc.getOrganiser(event);
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        event.eventTitle,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder<User>(
                                          stream: detailsBloc.organiserStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                'Organised by ${snapshot.data.displayName}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        125, 0, 0, 0)),
                                              );
                                            } else {
                                              return Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              );
                                            }
                                          }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Divider(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Venue
                                  Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: () {
                                        var navBlock =
                                            Provider.of<NavigationBloc>(context,
                                                listen: false);
                                        navBlock.addPlace(event.placeId);
                                        navBlock
                                            .navigate(Navigation.PLACE_DETAILS);
                                      },
                                      splashColor: Color.fromARGB(125, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          border: Border.all(
                                            color: Color.fromARGB(20, 0, 0, 0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Venue: ${event.venueName}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Date
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromARGB(20, 0, 0, 0),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Date: ${DateFormat('EEEE, dd MMMM').format(event.dateTime)}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Time
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromARGB(20, 0, 0, 0),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Time: ${DateFormat('h:m a').format(event.dateTime)}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Description
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromARGB(20, 0, 0, 0),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Description:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          Container(
                                            height: 100,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(event.description),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Attendees
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                '${event.attendees.length}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
