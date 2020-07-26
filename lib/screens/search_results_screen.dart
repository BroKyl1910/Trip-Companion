import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/map_controller_bloc.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/place_search_bloc.dart';
import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';
import 'package:tripcompanion/json_models/google_place_search_model.dart';
import 'package:tripcompanion/json_models/search_distance_matrix_model.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  SearchResultsScreen({this.query});

  @override
  Widget build(BuildContext context) {
    final searchBloc = Provider.of<PlaceSearchBloc>(context, listen: false);
    searchBloc.search(query);
    return StreamBuilder<SearchDistanceMatrixViewModel>(
        stream: Provider.of<PlaceSearchBloc>(context, listen: false)
            .placeResultStream,
        builder: (context, snapshot) {
          bool hasData = snapshot.hasData;
          print("Has data: $hasData");
//          if (hasData)
          return _buildResultsScreen(context, snapshot);
        });
  }

  Widget _buildResultsScreen(
      BuildContext context, AsyncSnapshot<SearchDistanceMatrixViewModel> snapshot) {
    List<PlaceSearchResult> results;
    List<GoogleDistanceMatrix> distances;
    bool hasData = snapshot.hasData;
    if (hasData) {
      results = snapshot.data.results;
      distances = snapshot.data.distances;
    }
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
                            "Search",
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
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
//                constraints: BoxConstraints.expand(),
                  child: (hasData)
                      ? _buildListView(context, results, distances)
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
      BuildContext context, List<PlaceSearchResult> results, List<GoogleDistanceMatrix> distances) {

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (BuildContext ctx, int index) {
            return _buildPrediction(ctx, results[index], distances[index]);
          }),
    );
  }

  Widget _buildPrediction(BuildContext context, PlaceSearchResult result, GoogleDistanceMatrix distance) {
    String dist;
    double distanceValue = distance.rows[0].elements[0].distance.value;
    if (distanceValue != null) {
      double km = distanceValue / 1000;
      dist = (km <= 1000) ? "${km.toStringAsFixed(1)} km" : 'Far';
    } else {
      dist = "N/A";
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          showPlaceDetails(context, result.placeId);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.navigation,
                        size: 17,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: Text(
                          dist,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
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
                          result.name ?? "",
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
                          result.formattedAddress ?? "",
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
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 20.0,
                    onPressed: () {
                      showPlaceDetails(context, result.placeId);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showPlaceDetails(BuildContext context, String placeId) {
    final bloc = Provider.of<NavigationBloc>(context, listen: false);
    bloc.navigate(Navigation.PLACE_DETAILS);
    bloc.addPlace(placeId);
  }
}
