import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_search_bloc.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/google_place_search_model.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  SearchResultsScreen({this.query});

  @override
  Widget build(BuildContext context) {
    final searchBloc = Provider.of<PlaceSearchBloc>(context, listen: false);
    searchBloc.search(query);
    return StreamBuilder<GooglePlaceSearchResult>(
        stream: Provider.of<PlaceSearchBloc>(context, listen: false)
            .placeResultStream,
        builder: (context, snapshot) {
          bool hasData = snapshot.hasData;
          print("Has data: $hasData");
//          if (hasData)
          return _buildResultsScreen(context, snapshot.data);

          return Container();
        });
  }

  Widget _buildResultsScreen(
      BuildContext context, GooglePlaceSearchResult result) {
//    final results = result.results;
    return Container(
      constraints: BoxConstraints.expand(),
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
                                var mapBloc = Provider.of<MapControllerBloc>(
                                    context,
                                    listen: false);
                                mapBloc.removeMarkers();
                                navBloc.navigate(Navigation.HOME);
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
                            "Search",
                            style: Theme.of(context).textTheme.title,
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
          ],
        ),
      ),
    );
  }
}
