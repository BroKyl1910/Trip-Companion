import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/create_event_bloc.dart';
import 'package:tripcompanion/blocs/distance_matrix_bloc.dart';
import 'package:tripcompanion/blocs/events_bloc.dart';
import 'package:tripcompanion/blocs/friends_bloc.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_details_bloc.dart';
import 'package:tripcompanion/blocs/autocomplete_search_bloc.dart';
import 'package:tripcompanion/blocs/place_distance_matrix_bloc.dart';
import 'package:tripcompanion/blocs/place_search_bloc.dart';
import 'package:tripcompanion/json_models/google_place_search_model.dart';
import 'package:tripcompanion/json_models/place_distance_matrix_model.dart';
import 'package:tripcompanion/models/event.dart';
import 'package:tripcompanion/screens/event_details_screen.dart';
import 'package:tripcompanion/screens/events_main_screen.dart';
import 'package:tripcompanion/screens/friends_main_screen.dart';
import 'package:tripcompanion/screens/home_screen.dart';
import 'package:tripcompanion/screens/place_details_screen.dart';
import 'package:tripcompanion/screens/search_results_screen.dart';
import 'package:tripcompanion/widgets/map_widget.dart';
import 'package:tripcompanion/widgets/navigation_bar.dart';

import 'create_event_screen.dart';

class MainAppController extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop(BuildContext context) async {
    KeyboardVisibilityNotification keyboardVisibilityNotification =
        new KeyboardVisibilityNotification();

    if (keyboardVisibilityNotification.isKeyboardVisible) {
      return true;
    }

    try {
      Provider.of<MapControllerBloc>(context, listen: false).removeMarkers();
      Provider.of<NavigationBloc>(context, listen: false).back();
    } catch (e) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        body: _buildBody(context),
        drawer: NavigationDrawer(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<Set<Marker>>(
          stream: Provider.of<MapControllerBloc>(context, listen: false)
              .markerStream,
          builder: (context, markersSnapshot) {
            return StreamBuilder<CameraUpdate>(
              stream: Provider.of<MapControllerBloc>(context, listen: false)
                  .mapCameraStream,
              builder: (context, cameraUpdateSnapshot) {
                return MapWidget(
                    cameraUpdate: cameraUpdateSnapshot.data,
                    markers: markersSnapshot.data);
              },
            );
          },
        ),
        StreamBuilder<Navigation>(
            stream: Provider.of<NavigationBloc>(context, listen: false)
                .navigationStream,
            //TODO: Change back to home
            initialData: Navigation.HOME,
//            initialData: Navigation.FRIENDS,
            builder: (context, snapshot) {
              Navigation screen = snapshot.data;

              switch (screen) {
                case Navigation.HOME:
                  Provider.of<NavigationBloc>(context, listen: false)
                      .addToNavStack(Navigation.HOME);
                  return HomeScreen(scaffoldKey: _scaffoldKey);
                  break;
                case Navigation.PLACE_DETAILS:
                  return StreamBuilder<String>(
                      stream:
                          Provider.of<NavigationBloc>(context, listen: false)
                              .placeIdStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Provider<PlaceDistanceMatrixBloc>(
                            create: (_) => PlaceDistanceMatrixBloc(),
                            dispose: (context, bloc) => bloc.dispose(),
                            child: PlaceDetailsScreen(placeId: snapshot.data),
                          );

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  break;
                case Navigation.SEARCH_RESULTS:
                  return StreamBuilder<String>(
                      stream:
                          Provider.of<NavigationBloc>(context, listen: false)
                              .searchQueryStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Provider<PlaceSearchBloc>(
                            create: (_) => PlaceSearchBloc(),
                            dispose: (context, bloc) => bloc.dispose(),
                            child: SearchResultsScreen(
                              query: snapshot.data,
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  break;
                case Navigation.CREATE_EVENT:
                  return StreamBuilder<PlaceDistanceMatrixViewModel>(
                    stream: Provider.of<NavigationBloc>(context, listen: false)
                        .placeDistanceMatrixStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Provider<CreateEventBloc>(
                          create: (_) => CreateEventBloc(),
                          dispose: (context, bloc) => bloc.dispose(),
                          child: CreateEventScreen(
                              placeDistanceMatrixViewModel: snapshot.data),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                  break;
                case Navigation.FRIENDS:
                  return Provider<FriendsBloc>(
                      create: (_) => FriendsBloc(),
                      dispose: (context, bloc) => bloc.dispose(),
                      child: FriendsMainScreen());
                  break;
                case Navigation.EVENTS:
                  return Provider<EventsBloc>(
                      create: (_) => EventsBloc(),
                      dispose: (context, bloc) => bloc.dispose(),
                      child: EventsMainScreen());
                  break;
                case Navigation.EVENT_DETAILS:
                  return StreamBuilder<Event>(
                      stream:
                          Provider.of<NavigationBloc>(context, listen: false)
                              .eventDetailsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Provider<EventsBloc>(
                              create: (_) => EventsBloc(),
                              dispose: (context, bloc) => bloc.dispose(),
                              child: EventDetailsScreen(snapshot.data));
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                  break;
                default:
                  return Container();
              }
            }),
      ],
    );
  }
}
