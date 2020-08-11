import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/event_details_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/helpers/alert_dialog_helper.dart';
import 'package:tripcompanion/helpers/firebase_messaging_helper.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/show_attendees_widget.dart';

enum EventStatus { ORGANISER, INVITED, ATTENDING }

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen(this.event);

  void _handleShowAttendees(BuildContext context) {
    Provider.of<EventDetailsBloc>(context, listen: false).showAttendees();
  }

  void _handleAttendeesClose(BuildContext context) {
    Provider.of<EventDetailsBloc>(context, listen: false).hideAttendees();
  }

  Widget _showAttendeesDialog(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: ShowAttendeesWidget(
        handleCloseDialog: _handleAttendeesClose,
        event: event,
      ),
    );
  }

  void _handleAcceptInvite(BuildContext context) async {
    User currentUser = Provider.of<User>(context, listen: false);
    currentUser.eventsAttending.add(event.uid);
    currentUser.eventRequests.remove(event.uid);

    event.attendees.add(currentUser.uid);
    event.invited.remove(currentUser.uid);

    await FirestoreDatabase().insertEvent(event);
    await FirestoreDatabase().insertUser(currentUser);

    FirebaseMessagingHelper.instance.sendNotificationToUser('Event invitation accepted', '${currentUser.displayName} has accepted your invitation to ${event.eventTitle}', await FirestoreDatabase().getUser(event.organiser));
    FirebaseMessagingHelper.instance.subscribeToEvent(event.uid);

    //Refresh
    refresh(context);
  }

  Future<void> _handleDeclineInvite(BuildContext context) async {
    AlertDialogHelper.showConfirmationDialog(
        context, 'Are you sure you want to decline this invitation?', () async {
      User currentUser = Provider.of<User>(context, listen: false);
      currentUser.eventRequests.remove(event.uid);
      event.invited.remove(currentUser.uid);

      await FirestoreDatabase().insertEvent(event);
      await FirestoreDatabase().insertUser(currentUser);

      _navigateBack(context);
    });
  }

  Future<void> _handleCancelAttendance(BuildContext context) async {
    AlertDialogHelper.showConfirmationDialog(context,
        'Are you sure you want to cancel your attendance at this event?',
        () async {
      User currentUser = Provider.of<User>(context, listen: false);
      event.attendees.remove(currentUser.uid);
      currentUser.eventsAttending.remove(event.uid);

      await FirestoreDatabase().insertUser(currentUser);
      await FirestoreDatabase().insertEvent(event);

      FirebaseMessagingHelper.instance.unsubscribeFromEvent(event.uid);

      _navigateBack(context);
    });
  }

  Future<void> _handleCancelEvent(BuildContext context) async {
    AlertDialogHelper.showConfirmationDialog(
        context, 'Are you sure you want to cancel this event?', () async {
      User currentUser = Provider.of<User>(context, listen: false);

      //Remove from invites on invitees
      var invited = await FirestoreDatabase().getUsers(event.invited);
      for (int i = 0; i < invited.length; i++) {
        invited[i].eventRequests.remove(event.uid);
        invited[i].eventsAttending.remove(event.uid);
        await FirestoreDatabase().insertUser(invited[i]);
      }

      //Remove from attending on attendees
      var attendees = await FirestoreDatabase().getUsers(event.attendees);
      for (int i = 0; i < attendees.length; i++) {
        attendees[i].eventsAttending.remove(event.uid);
        await FirestoreDatabase().insertUser(attendees[i]);
      }

      //Remove from organised on organiser
      currentUser.eventsOrganised.remove(event.uid);
      await FirestoreDatabase().insertUser(currentUser);
      await FirestoreDatabase().deleteEvent(event);

      FirebaseMessagingHelper.instance.sendNotificationToEventTopic('Event cancelled', '${event.eventTitle} has been cancelled', event.uid);

      _navigateBack(context);
    });
  }

  void _handleEditEvent(BuildContext context) {
    var navBlock = Provider.of<NavigationBloc>(context, listen: false);
    navBlock.addEditEvent(event);
    navBlock.navigate(Navigation.EDIT_EVENT);
  }

  void _navigateBack(BuildContext context) {
    var navBlock = Provider.of<NavigationBloc>(context, listen: false);
    navBlock.navigate(Navigation.EVENTS);
  }

  void refresh(BuildContext context) {
    var detailsBloc = Provider.of<EventDetailsBloc>(context, listen: false);
    detailsBloc.refresh();
  }

  Widget _buildEventOptions(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    String prompt;
    List<Widget> actions;
    if (currentUser.eventsOrganised.contains(event.uid)) {
      // Organiser
      prompt = 'You are the organiser';
      actions = [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _handleEditEvent(context);
              },
              color: Colors.white,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_busy),
              onPressed: () async {
                await _handleCancelEvent(context);
              },
              color: Colors.white,
            ),
          ),
        ),
      ];
    } else if (currentUser.eventRequests.contains(event.uid)) {
      // Invited
      prompt = 'You are invited';
      actions = [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_available),
              onPressed: () {
                _handleAcceptInvite(context);
              },
              color: Colors.white,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_busy),
              onPressed: () async {
                await _handleDeclineInvite(context);
              },
              color: Colors.white,
            ),
          ),
        ),
      ];
    } else {
      // Attending
      prompt = 'You are attending';
      actions = [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_busy),
              onPressed: () async {
                await _handleCancelAttendance(context);
              },
              color: Colors.white,
            ),
          ),
        ),
      ];
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              prompt,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: actions,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var detailsBloc = Provider.of<EventDetailsBloc>(context, listen: false);
    detailsBloc.getOrganiser(event);
    return StreamBuilder<bool>(
        stream: detailsBloc.refreshStream,
        builder: (context, snapshot) {
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
                                          var navBloc =
                                              Provider.of<NavigationBloc>(
                                                  context,
                                                  listen: false);
                                          var mapBloc =
                                              Provider.of<MapControllerBloc>(
                                                  context,
                                                  listen: false);
                                          mapBloc.removeMarkers();
                                          _navigateBack(context);
                                        },
                                        splashColor:
                                            Color.fromARGB(130, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "Event Details",
                                      style:
                                          Theme.of(context).textTheme.headline6,
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
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(120, 0, 0, 0),
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0)
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildEventOptions(context)),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                event.eventTitle,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            StreamBuilder<User>(
                                                stream:
                                                    detailsBloc.organiserStream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Flexible(
                                                      child: Text(
                                                        'Organised by ${snapshot.data.displayName}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    125,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                      ),
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
                                                  Provider.of<NavigationBloc>(
                                                      context,
                                                      listen: false);
                                              navBlock.addPlace(event.placeId);
                                              navBlock.navigate(
                                                  Navigation.PLACE_DETAILS);
                                            },
                                            splashColor:
                                                Color.fromARGB(125, 0, 0, 0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue[400],
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      20, 0, 0, 0),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                              color:
                                                  Color.fromARGB(20, 0, 0, 0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Date: ${DateFormat('EEEE, dd MMMM').format(event.dateTime)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
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
                                              color:
                                                  Color.fromARGB(20, 0, 0, 0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Time: ${DateFormat('h:mm a').format(event.dateTime)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
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
                                              color:
                                                  Color.fromARGB(20, 0, 0, 0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                SizedBox(
                                                  height: 5,
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
                                        Material(
                                          type: MaterialType.transparency,
                                          child: InkWell(
                                            onTap: () {
                                              _handleShowAttendees(context);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.blue[400],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              '${event.attendees.length}',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text((event.attendees
                                                                    .length ==
                                                                1
                                                            ? 'person'
                                                            : 'people') +
                                                        ' attending')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
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
              StreamBuilder<bool>(
                stream: Provider.of<EventDetailsBloc>(context, listen: false)
                    .showAttendeesStream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == false) {
                    return Container();
                  }
                  return _showAttendeesDialog(context);
                },
              )
            ],
          );
        });
  }
}
