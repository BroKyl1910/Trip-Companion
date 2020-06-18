import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';

import 'google_place_search_model.dart';

class SearchDistanceMatrixViewModel {
  final List<PlaceSearchResult> results;
  final List<GoogleDistanceMatrix> distances;

  SearchDistanceMatrixViewModel(this.results, this.distances);
}