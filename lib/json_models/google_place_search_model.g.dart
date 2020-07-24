// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePlaceSearchResult _$GooglePlaceSearchResultFromJson(
    Map<String, dynamic> json) {
  return GooglePlaceSearchResult(
    results: (json['results'] as List)
        .map((e) => PlaceSearchResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GooglePlaceSearchResultToJson(
        GooglePlaceSearchResult instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

PlaceSearchResult _$PlaceSearchResultFromJson(Map<String, dynamic> json) {
  return PlaceSearchResult(
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    name: json['name'] as String,
    formattedAddress: json['formatted_address'] as String,
    placeId: json['place_id'] as String,
  );
}

Map<String, dynamic> _$PlaceSearchResultToJson(PlaceSearchResult instance) =>
    <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'geometry': instance.geometry,
      'name': instance.name,
      'place_id': instance.placeId,
    };
