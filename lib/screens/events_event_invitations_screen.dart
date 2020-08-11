import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/events_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/helpers/alert_dialog_helper.dart';
import 'package:tripcompanion/helpers/firebase_messaging_helper.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/event_user_view_model.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';

class EventInvitationsScreen extends StatelessWidget {
  Widget _buildListView(
      BuildContext context, AsyncSnapshot<List<EventUserViewModel>> snapshot) {
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

  Widget _buildEvent(BuildContext context, EventUserViewModel viewModel) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          var navBloc = Provider.of<NavigationBloc>(context, listen: false);
          navBloc.addEventDetails(viewModel.event);
          navBloc.navigate(Navigation.EVENT_DETAILS);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  (viewModel.user.imageUrl == null ||
                          viewModel.user.imageUrl.isEmpty)
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
                                viewModel.user.displayName[0].toUpperCase(),
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
                              imageUrl: viewModel.user.imageUrl,
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
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          viewModel.event.eventTitle,
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
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          viewModel.user.displayName,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0),
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          viewModel.event.venueName,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0),
                              fontSize: 14),
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
                              .format(viewModel.event.dateTime),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0),
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          DateFormat('h:mm a').format(viewModel.event.dateTime),
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
              Column(
                children: <Widget>[
                  _buildResponseButtons(context, viewModel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildResponseButtons(BuildContext context, EventUserViewModel viewModel) {
    User currentUser = Provider.of<User>(context, listen: false);

    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_available),
              iconSize: 20.0,
              onPressed: () async {
                await _handleAcceptInvite(
                    context, currentUser, viewModel.event);
              },
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.event_busy),
              iconSize: 20.0,
              onPressed: () async {
                await _handleDeclineInvite(
                    context, currentUser, viewModel.event);
              },
            ),
          ),
        )
      ],
    );
  }

  _handleAcceptInvite(
      BuildContext context, User currentUser, Event event) async {
    currentUser.eventsAttending.add(event.uid);
    currentUser.eventRequests.remove(event.uid);

    event.attendees.add(currentUser.uid);
    event.invited.remove(currentUser.uid);

    await FirestoreDatabase().insertEvent(event);
    await FirestoreDatabase().insertUser(currentUser);

    FirebaseMessagingHelper.instance.sendNotificationToUser('Event invitation accepted', '${currentUser.displayName} has accepted your invitation to ${event.eventTitle}', await FirestoreDatabase().getUser(event.organiser));
    FirebaseMessagingHelper.instance.subscribeToEvent(event.uid);


    Provider.of<EventsBloc>(context, listen: false)
        .getEventInvites(currentUser);
  }

  void _handleDeclineInvite(
      BuildContext context, User currentUser, Event event) async {
    AlertDialogHelper.showConfirmationDialog(
        context, 'Are you sure you want to cancel this event invite?',
        () async {
      currentUser.eventRequests.remove(event.uid);
      event.invited.remove(currentUser.uid);

      await FirestoreDatabase().insertEvent(event);
      await FirestoreDatabase().insertUser(currentUser);

      Provider.of<EventsBloc>(context, listen: false)
          .getEventInvites(currentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context, listen: false);
    var eventsBloc = Provider.of<EventsBloc>(context, listen: false);
    eventsBloc.getEventInvites(currentUser);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<bool>(
                stream: eventsBloc.refreshStream,
                builder: (context, refreshSnapshot) {
                  return StreamBuilder<List<EventUserViewModel>>(
                      stream: eventsBloc.eventInvitesStream,
                      builder: (context, eventInvitesSnapshot) {
                        if (!eventInvitesSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (eventInvitesSnapshot.data.length > 0) {
                          return _buildListView(context, eventInvitesSnapshot);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'You have no new event invites',
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
