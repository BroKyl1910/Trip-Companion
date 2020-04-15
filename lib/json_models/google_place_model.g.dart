// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePlaceResult _$GooglePlaceResultFromJson(Map<String, dynamic> json) {
  return GooglePlaceResult(
    result: Result.fromJson(json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GooglePlaceResultToJson(GooglePlaceResult instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
    json['formattedAddress'] as String,
    json['formattedPhoneNumber'] as String,
    json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    json['id'] as String,
    json['internationalPhoneNumber'] as String,
    json['name'] as String,
    json['openingHours'] == null
        ? null
        : OpeningHours.fromJson(json['openingHours'] as Map<String, dynamic>),
    json['placeId'] as String,
    (json['rating'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'formattedAddress': instance.formattedAddress,
      'formattedPhoneNumber': instance.formattedPhoneNumber,
      'geometry': instance.geometry,
      'id': instance.id,
      'internationalPhoneNumber': instance.internationalPhoneNumber,
      'name': instance.name,
      'openingHours': instance.openingHours,
      'placeId': instance.placeId,
      'rating': instance.rating,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return OpeningHours(
    json['openNow'] as bool,
    (json['periods'] as List)
        ?.map((e) =>
            e == null ? null : Period.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'openNow': instance.openNow,
      'periods': instance.periods,
    };

Period _$PeriodFromJson(Map<String, dynamic> json) {
  return Period(
    json['closeTime'] == null
        ? null
        : OperatingTime.fromJson(json['closeTime'] as Map<String, dynamic>),
    json['openTime'] == null
        ? null
        : OperatingTime.fromJson(json['openTime'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'closeTime': instance.closeTime,
      'openTime': instance.openTime,
    };

OperatingTime _$OperatingTimeFromJson(Map<String, dynamic> json) {
  return OperatingTime(
    json['day'] as int,
    json['time'] as String,
  );
}

Map<String, dynamic> _$OperatingTimeToJson(OperatingTime instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) {
  return Geometry(
    Location.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    (json['lat'] as num).toDouble(),
    (json['lng'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
