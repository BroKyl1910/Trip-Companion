import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:tripcompanion/blocs/create_event_bloc.dart';
import 'package:tripcompanion/blocs/error_bloc.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/helpers/firebase_messaging_helper.dart';
import 'package:tripcompanion/helpers/validators.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/db.dart';
import 'package:tripcompanion/widgets/error_dialog.dart';
import 'package:tripcompanion/widgets/invite_friends_create_widget.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';

class CreateEventScreen extends StatefulWidget {
  final PlaceDistanceMatrixViewModel placeDistanceMatrixViewModel;

  CreateEventScreen({this.placeDistanceMatrixViewModel});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with EventValidators, SingleTickerProviderStateMixin {
  final TextEditingController _venueTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _timeTextController = TextEditingController();
  final TextEditingController _friendsTextController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  void _shiftFocus(BuildContext context, FocusNode nextNode) {
    FocusScope.of(context).requestFocus(nextNode);
  }

  AnimationController _errorAnimationController;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 200),
    );
  }

  bool _validateInput() {
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);
    DateTime date = bloc.getLastDate();
    DateTime time = bloc.getLastTime();
    String name = _nameTextController.text;
    String desc = _descriptionTextController.text;
    if (date == null) {
      _showErrorDialog('Please enter a date');
      return false;
    } else if (time == null) {
      _showErrorDialog('Please enter a time');
      return false;
    } else if (name.isEmpty) {
      _showErrorDialog('Please enter an event name');
      return false;
    } else if (desc.isEmpty) {
      _showErrorDialog('Please enter a description');
      return false;
    }
    return true;
  }

  void _handleSave(BuildContext context) async {
    if (!_validateInput()) return;

    User currentUser = Provider.of<User>(context, listen: false);
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);
    DateTime date = bloc.getLastDate();
    DateTime time = bloc.getLastTime();
    List<User> invited = bloc.getLastInvitedFriends() ?? new List<User>();
    List<String> invitedStr = new List<String>();
    for (int i = 0; i < invited.length; i++) {
      invitedStr.add(invited[i].uid);
    }
    Location placeLocation = this
        .widget
        .placeDistanceMatrixViewModel
        .PlaceResult
        .result
        .geometry
        .location;
    LatLng placeLatLng = new LatLng(placeLocation.lat, placeLocation.lng);
    String uid = randomAlphaNumeric(28);
    Event event = new Event(
        uid: uid,
        dateTime: new DateTime(
            date.year, date.month, date.day, time.hour, time.minute),
        venueName:
            widget.placeDistanceMatrixViewModel.PlaceResult.result.name ??
                widget.placeDistanceMatrixViewModel.PlaceResult.result
                    .formattedAddress,
        eventTitle: _nameTextController.text,
        description: _descriptionTextController.text,
        organiser: currentUser.uid,
        attendees: new List<String>(),
        invited: invitedStr,
        placeId: this
            .widget
            .placeDistanceMatrixViewModel
            .PlaceResult
            .result
            .placeId);

    await FirestoreDatabase().insertEvent(event);

    for (int i = 0; i < invited.length; i++) {
      invited[i].eventRequests.add(uid);
      await FirestoreDatabase().insertUser(invited[i]);
      FirebaseMessagingHelper.instance.sendNotificationToUser('Event invitation received', '${currentUser.displayName} has invited you to an event', invited[i]);
    }

    currentUser.eventsOrganised.add(uid);
    await FirestoreDatabase().insertUser(currentUser);

    var navBloc = Provider.of<NavigationBloc>(context, listen: false);
    var mapBloc = Provider.of<MapControllerBloc>(context, listen: false);
    mapBloc.removeMarkers();
    navBloc.addEventDetails(event);
    navBloc.navigate(Navigation.EVENT_DETAILS);
  }

  void _showErrorDialog(String errorMessage) {
    _errorAnimationController.forward();

    final ErrorBloc bloc = Provider.of<ErrorBloc>(context, listen: false);
    bloc.setHasError(true);
    bloc.errorMessage = errorMessage;
  }

  void _hideErrorDialog() {
    final ErrorBloc bloc = Provider.of<ErrorBloc>(context, listen: false);
    bloc.setHasError(false);
  }

  Widget _buildDatePicker(BuildContext context) {
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);

    return StreamBuilder<DateTime>(
        stream: bloc.dateStream,
        builder: (context, snapshot) {
          String dateString;
          if (snapshot.hasData) {
            dateString = DateFormat.yMMMMEEEEd().format(snapshot.data);
          } else {
            dateString = 'Tap to select date...';
          }

          _dateTextController.text = dateString;

          return GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(), onConfirm: (date) {
                bloc.addDate(date);
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: CustomFlatTextField(
                      textEditingController: _dateTextController,
                      enabled: false,
                      textColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTimePicker(BuildContext context) {
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);

    return StreamBuilder<DateTime>(
        stream: bloc.timeStream,
        builder: (context, snapshot) {
          String timeString;
          if (snapshot.hasData) {
            timeString = DateFormat.Hm().format(snapshot.data);
          } else {
            timeString = 'Tap to select time...';
          }

          _timeTextController.text = timeString;
          DateTime now = DateTime.now();
          DateTime nowNoSeconds = new DateTime(
              now.year, now.month, now.day, now.hour, now.minute, 0);
          return GestureDetector(
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  currentTime: nowNoSeconds, onConfirm: (time) {
                bloc.addTime(time);
              }, locale: LocaleType.en);
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: CustomFlatTextField(
                      textEditingController: _timeTextController,
                      enabled: false,
                      textColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildInviteFriends(BuildContext context) {
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);

    return StreamBuilder<List<User>>(
        stream: bloc.inviteFriendsStream,
        builder: (context, snapshot) {
          String friendsString;

          if (snapshot.hasData) {
            int numInvited = snapshot.data.length;
            if (numInvited == 0) {
              friendsString = 'Tap to invite friends...';
            } else {
              friendsString = '${snapshot.data.length} friend' +
                  (numInvited > 1 ? 's' : '') +
                  ' selected';
            }
          } else {
            friendsString = 'Tap to invite friends...';
          }

          _friendsTextController.text = friendsString;

          return GestureDetector(
            onTap: () {
              bloc.showInviteFriends();
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: CustomFlatTextField(
                      textEditingController: _friendsTextController,
                      enabled: false,
                      textColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _handleInviteFriendsClose(BuildContext context) {
    Provider.of<CreateEventBloc>(context, listen: false).hideInviteFriends();
  }

  Widget _showInviteFriendsDialog(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: Provider<FriendsBloc>(
        create: (_) => FriendsBloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: InviteFriendsCreateWidget(
          handleCloseDialog: _handleInviteFriendsClose,
          handleSaveList: _handleInviteFriendsClose,
        ),
      ),
    );
  }

  Widget _buildErrorDialog(bool hasError, String errorMessage) {
    if (hasError == true) {
      return Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                ErrorDialog(
                  errorMessage: errorMessage,
                  onClosed: _hideErrorDialog,
                  animationController: _errorAnimationController,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    _venueTextController.text = 'Venue: ' +
            widget.placeDistanceMatrixViewModel.PlaceResult.result.name ??
        widget.placeDistanceMatrixViewModel.PlaceResult.result.formattedAddress;

    final errorBloc = Provider.of<ErrorBloc>(context); //, listen: false
    return StreamBuilder<bool>(
        stream: errorBloc.hasErrorStream,
        initialData: false,
        builder: (context, hasErrorSnapshot) {
          bool hasError = hasErrorSnapshot.data;
          String errorMessage = errorBloc.errorMessage;
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
                                          navBloc.back();
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
                                      "Create Event",
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
                        height: 40.0,
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
                                        CustomFlatTextField(
                                          hintText: widget
                                                      .placeDistanceMatrixViewModel !=
                                                  null
                                              ? 'Venue: ' +
                                                      widget
                                                          .placeDistanceMatrixViewModel
                                                          .PlaceResult
                                                          .result
                                                          .name ??
                                                  widget
                                                      .placeDistanceMatrixViewModel
                                                      .PlaceResult
                                                      .result
                                                      .formattedAddress
                                              : "",
                                          enabled: false,
                                          textEditingController:
                                              _venueTextController,
                                          action: TextInputAction.next,
                                          onEditingComplete: () {
                                            _shiftFocus(
                                                context, _nameFocusNode);
                                          },
//                                onChanged: (text) => _updateState(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildDatePicker(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTimePicker(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomFlatTextField(
                                          hintText: 'Event Name',
                                          textEditingController:
                                              _nameTextController,
                                          action: TextInputAction.next,
                                          focusNode: _nameFocusNode,
                                          onEditingComplete: () {
                                            _shiftFocus(
                                                context, _descriptionFocusNode);
                                          },
//                                onChanged: (text) => _updateState(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomFlatTextField(
                                            hintText: 'Description',
                                            textEditingController:
                                                _descriptionTextController,
                                            maxLines: 6,
                                            keyboardType:
                                                TextInputType.multiline,
                                            action: TextInputAction.done,
                                            focusNode: _descriptionFocusNode),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildInviteFriends(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      CustomRaisedButton(
                                        color: Colors.blue[400],
                                        textColor: Colors.white,
                                        text: 'Save',
                                        onTap: () {
                                          _handleSave(context);
                                        },
                                      ),
                                    ],
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
                stream: Provider.of<CreateEventBloc>(context, listen: false)
                    .showInviteFriendsStream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == false) {
                    return Container();
                  }
                  return _showInviteFriendsDialog(context);
                },
              ),
              _buildErrorDialog(hasError, errorMessage),
            ],
          );
        });
  }
}
