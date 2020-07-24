import 'package:json_annotation/json_annotation.dart';
import 'package:tripcompanion/json_models/google_place_model.dart';

part 'google_place_search_model.g.dart';

@JsonSerializable(nullable: false)
class GooglePlaceSearchResult {
  List<PlaceSearchResult> results;

  GooglePlaceSearchResult({this.results});
  factory GooglePlaceSearchResult.fromJson(Map<String, dynamic> json) => _$GooglePlaceSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePlaceSearchResultToJson(this);
}

@JsonSerializable(nullable: true)
class PlaceSearchResult {
  String formattedAddress;
  Geometry geometry;
  String name;
  String placeId;

  PlaceSearchResult({this.geometry, this.name, this.formattedAddress, this.placeId});
  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) => _$PlaceSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceSearchResultToJson(this);
}