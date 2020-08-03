import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/create_event_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/widgets/invite_friends_widget.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';

class CreateEventScreen extends StatelessWidget {
  final PlaceDistanceMatrixViewModel placeDistanceMatrixViewModel;

  CreateEventScreen({this.placeDistanceMatrixViewModel});

  //Text controllers
  final TextEditingController _venueTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _timeTextController = TextEditingController();
  final TextEditingController _friendsTextController = TextEditingController();

  //Focus Nodes
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  //Focus Shifting
  void _shiftFocus(BuildContext context, FocusNode nextNode) {
    FocusScope.of(context).requestFocus(nextNode);
  }

  void _handleNext(BuildContext context) async {
    var bloc = Provider.of<CreateEventBloc>(context, listen: false);
    DateTime date = await bloc.dateStream.last;
    DateTime time = await bloc.timeStream.last;
    Location placeLocation =
        this.placeDistanceMatrixViewModel.PlaceResult.result.geometry.location;
    LatLng placeLatLng = new LatLng(placeLocation.lat, placeLocation.lng);
    Event event = new Event(
        dateTime: new DateTime(
            date.year, date.month, date.day, time.hour, time.minute),
        organiser: Provider.of<User>(context, listen: false).uid,
        attendees: new List<String>(),
        invited: new List<String>(),
        location: placeLatLng);
  }

  void _showErrorDialog(String errorMessage) {}

  void _hideErrorDialog() {}

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
                      borderRadius: BorderRadius.circular(10.0)
                    ),
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
                        borderRadius: BorderRadius.circular(10.0)
                    ),
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

    return StreamBuilder<List<String>>(
        stream: bloc.inviteFriendsStream,
        builder: (context, snapshot) {
          String friendsString;
          if (snapshot.hasData) {
            friendsString = '${snapshot.data.length} friends invited';
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
                        borderRadius: BorderRadius.circular(10.0)
                    ),
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

  void _handleInviteFriendsSave(){

  }

  void _handleInviteFriendsClose(BuildContext context){
    Provider.of<CreateEventBloc>(context, listen: false).hideInviteFriends();
  }

  Widget _showInviteFriendsDialog(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: InviteFriendsWidget(handleCloseDialog: _handleInviteFriendsClose, handleSaveList: _handleInviteFriendsClose,),
    );
  }

  @override
  Widget build(BuildContext context) {
    _venueTextController.text =
        'Venue: ' + placeDistanceMatrixViewModel.PlaceResult.result.name ??
            placeDistanceMatrixViewModel.PlaceResult.result.formattedAddress;
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
                                "Create Event",
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
                                  CustomFlatTextField(
                                    hintText:
                                        placeDistanceMatrixViewModel != null
                                            ? 'Venue: ' +
                                                    placeDistanceMatrixViewModel
                                                        .PlaceResult
                                                        .result
                                                        .name ??
                                                placeDistanceMatrixViewModel
                                                    .PlaceResult
                                                    .result
                                                    .formattedAddress
                                            : "",
                                    enabled: false,
                                    textEditingController: _venueTextController,
                                    action: TextInputAction.next,
                                    onEditingComplete: () {
                                      _shiftFocus(context, _nameFocusNode);
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
                                    textEditingController: _nameTextController,
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
                                      keyboardType: TextInputType.multiline,
                                      action: TextInputAction.done,
                                      focusNode: _descriptionFocusNode),
                                  SizedBox(height: 10,),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomRaisedButton(
                                color: Colors.blue[400],
                                textColor: Colors.white,
                                text: 'Next',
                                onTap: () {
                                  _handleNext(context);
                                },
                              ),
                            ],
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
        )
      ],
    );
  }
}
