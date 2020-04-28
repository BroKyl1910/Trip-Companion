import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/blocs/search_maps_bloc.dart';
import 'package:tripcompanion/json_models/google_autocomplete_model.dart';

class MapSearchBar extends StatelessWidget {
  final Function handleOpenDrawer;

  MapSearchBar({this.handleOpenDrawer});

  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SearchMapsBloc bloc = Provider.of<SearchMapsBloc>(context, listen: false);
    return _buildBody(context, bloc);
  }

  void onTextChanged(String text, BuildContext context) {
    SearchMapsBloc bloc = Provider.of<SearchMapsBloc>(context, listen: false);
    bloc.autocomplete(text);
  }

  void showPlaceDetails(BuildContext context, String placeId) {
    final bloc = Provider.of<NavigationBloc>(context, listen: false);
    bloc.navigate(Navigation.PLACE_DETAILS);
    bloc.addPlace(placeId);
  }

  Widget _buildBody(BuildContext context, SearchMapsBloc bloc) {
    return StreamBuilder<GoogleAutocompleteResult>(
        stream: bloc.autoCompleteStream,
        builder: (context, snapshot) {
          return Container(
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
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          type: MaterialType.transparency,
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 20.0,
                            onPressed: handleOpenDrawer,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 200.0,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        controller: _searchTextController,
                        onChanged: (val) => onTextChanged(val, context),
                      ),
                    )
                  ],
                ),
                _buildListView(context, snapshot),
              ],
            ),
          );
        });
  }

  Widget _buildListView(
      BuildContext context, AsyncSnapshot<GoogleAutocompleteResult> snapshot) {
    if (!snapshot.hasData || snapshot.data.predictions.length == 0)
      return Container(
        height: 0,
        width: 0,
      );
    print("Listview has data");
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.predictions.length,
          itemBuilder: (BuildContext ctx, int index) {
            return _buildPrediction(ctx, snapshot.data.predictions[index]);
          }),
    );
  }

  Widget _buildPrediction(BuildContext context, Prediction prediction) {
    String dist;
    if (prediction.distanceMeters != null) {
      double km = prediction.distanceMeters / 1000;
      dist = (km <= 1000) ? "${km.toStringAsFixed(1)} km" : 'Far';
    } else {
      dist = "N/A";
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          showPlaceDetails(context, prediction.placeId);
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
                          prediction.structuredFormatting.mainText ?? "",
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
                          prediction.structuredFormatting.secondaryText ?? "",
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
                      showPlaceDetails(context, prediction.placeId);
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
}
