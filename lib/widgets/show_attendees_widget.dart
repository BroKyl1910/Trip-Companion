import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/event_details_bloc.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';

class ShowAttendeesWidget extends StatelessWidget {

  final Function handleCloseDialog;
  final Event event;
  ShowAttendeesWidget({this.handleCloseDialog, this.event});

  Widget _buildListView(
      BuildContext context, List<User> attendees) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: attendees.length,
        itemBuilder: (BuildContext ctx, int index) {
          return _buildAttendee(
              ctx,
              attendees[index],);
        });
  }

  Widget _buildAttendee(BuildContext context, User attendee) {

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  (attendee.imageUrl == null || attendee.imageUrl.isEmpty)
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
                          attendee.displayName[0].toUpperCase(),
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
                        imageUrl: attendee.imageUrl,
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
                          attendee.displayName,
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
                          attendee.email,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var eventDetailsBloc = Provider.of<EventDetailsBloc>(context, listen: false);
    eventDetailsBloc.getAttendees(event);

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
                              'Attendees',
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
                                            handleCloseDialog(context);
                                          },
                                          splashColor:
                                          Color.fromARGB(130, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                          stream: eventDetailsBloc.attendeesStream,
                          builder: (context, attendeesSnapshot) {
                            if (attendeesSnapshot.hasData) {
                              var attendees = attendeesSnapshot.data;
                              return _buildListView(context, attendees);
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
