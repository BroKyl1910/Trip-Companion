import 'package:tripcompanion/json_models/google_distance_matrix_model.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';

class PlaceDistanceMatrixViewModel{
  final GooglePlaceResult PlaceResult;
  final GoogleDistanceMatrix DistanceMatrix;

  PlaceDistanceMatrixViewModel(this.PlaceResult, this.DistanceMatrix);
}