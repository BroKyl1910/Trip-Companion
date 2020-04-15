import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_details_bloc.dart';
import 'package:tripcompanion/screens/home_screen.dart';
import 'package:tripcompanion/screens/place_details_screen.dart';
import 'package:tripcompanion/widgets/map_widget.dart';
import 'package:tripcompanion/widgets/navigation_bar.dart';

class MainAppController extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
      drawer: NavigationDrawer(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<Set<Marker>>(
          stream: Provider.of<MapControllerBloc>(context, listen: false)
              .markerStream,
          builder: (context, markersSnapshot){
            return StreamBuilder<CameraUpdate>(
              stream: Provider.of<MapControllerBloc>(context, listen: false)
                  .mapCameraStream,
              builder: (context, cameraUpdateSnapshot) {
                return MapWidget(
                  cameraUpdate: cameraUpdateSnapshot.data,
                  markers: markersSnapshot.data
                );
              },
            );
          },
        ),
        StreamBuilder<Navigation>(
            stream: Provider.of<NavigationBloc>(context, listen: false)
                .navigationStream,
            initialData: Navigation.HOME,
            builder: (context, snapshot) {
              Navigation screen = snapshot.data;
              switch (screen) {
                case Navigation.HOME:
                  return HomeScreen(scaffoldKey: _scaffoldKey);
                  break;
                case Navigation.PLACE_DETAILS:
                  return StreamBuilder<String>(
                      stream:
                          Provider.of<NavigationBloc>(context, listen: false)
                              .placeIdStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Provider<PlaceDetailsBloc>(
                            create: (_) => PlaceDetailsBloc(),
                            dispose: (context, bloc) => bloc.dispose(),
                            child: PlaceDetailsScreen(placeId: snapshot.data),
                          );

                        return Center(
                          child: CircularProgressIndicator(),
                        );
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
