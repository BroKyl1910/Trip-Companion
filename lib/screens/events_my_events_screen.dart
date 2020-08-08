import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/events_bloc.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class MyEventsScreen extends StatelessWidget {
  Widget _buildListView(
      BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
            return _buildEvent(ctx, snapshot.data[index]);
          }),
    );
  }

  Widget _buildEvent(BuildContext context, Event event) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: (){
          var navBloc = Provider.of<NavigationBloc>(context, listen: false);
          navBloc.addEventDetails(event);
          navBloc.navigate(Navigation.EVENT_DETAILS);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          event.eventTitle,
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
                          event.venueName,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0), fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          DateFormat('EEEE dd MMMM')
                              .format(event.dateTime),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0), fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          DateFormat('h:mm a').format(event.dateTime),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color.fromARGB(120, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _buildEditEventButton(context, event),
                      _buildCancelEventButton(context, event),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  _buildEditEventButton(BuildContext context, Event event) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          icon: Icon(Icons.edit),
          iconSize: 20.0,
          onPressed: () async {
            _handleEditEvent(context, event);
          },
        ),
      ),
    );
  }

  _buildCancelEventButton(BuildContext context, Event event) {
    User currentUser = Provider.of<User>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          icon: Icon(Icons.event_busy),
          iconSize: 20.0,
          onPressed: () async {
            _handleCancelEvent(context, event);
          },
        ),
      ),
    );
  }

  _handleEditEvent(BuildContext context, Event event){
    var navBlock = Provider.of<NavigationBloc>(context, listen: false);
    navBlock.addEditEvent(event);
    navBlock.navigate(Navigation.EDIT_EVENT);
  }

  _handleCancelEvent(BuildContext context, Event event) async{
    User currentUser = Provider.of<User>(context, listen: false);

    //Remove from invites on invitees
    var invited = await FirestoreDatabase().getUsers(event.invited);
    for(int i = 0; i < invited.length; i++){
      invited[i].eventRequests.remove(event.uid);
      invited[i].eventsAttending.remove(event.uid);
      FirestoreDatabase().insertUser(invited[i]);
    }

    //Remove from attending on attendees
    var attendees = await FirestoreDatabase().getUsers(event.attendees);
    for(int i = 0; i < attendees.length; i++){
      attendees[i].eventsAttending.remove(event.uid);
      FirestoreDatabase().insertUser(attendees[i]);
    }

    //Remove from organised on organiser
    currentUser.eventsOrganised.remove(event.uid);
    FirestoreDatabase().insertUser(currentUser);
    FirestoreDatabase().deleteEvent(event);
    Provider.of<EventsBloc>(context, listen: false).getMyEvents(currentUser);

  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    var eventsBloc = Provider.of<EventsBloc>(context, listen: false);
    eventsBloc.getMyEvents(currentUser);
    return Padding(
      padding: const EdgeInsets.only(top:16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Event>>(
                stream: eventsBloc.myEventsStream,
                builder: (context, eventsSnapshot) {
                  return StreamBuilder<bool>(
                      stream: eventsBloc.refreshStream,
                      builder: (context, refreshSnapshot) {
                        if(!eventsSnapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (eventsSnapshot.data.length > 0) {
                          return _buildListView(context, eventsSnapshot);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Create some events to get started!',
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
