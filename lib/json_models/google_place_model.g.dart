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
    json['formatted_address'] as String,
    json['formatted_phone_number'] as String,
    Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    json['id'] as String,
    json['international_phone_number'] as String,
    json['name'] as String,
    OpeningHours.fromJson(json['opening_hours'] as Map<String, dynamic>),
    json['place_id'] as String,
    json['rating'] as double,
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'formatted_phone_number': instance.formattedPhoneNumber,
      'geometry': instance.geometry,
      'id': instance.id,
      'international_phone_number': instance.internationalPhoneNumber,
      'name': instance.name,
      'opening_hours': instance.openingHours,
      'place_id': instance.placeId,
      'rating': instance.rating,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return OpeningHours(
    json['open_now'] as bool,
    (json['periods'] as List)
        .map((e) => Period.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'open_now': instance.openNow,
      'periods': instance.periods,
    };

Period _$PeriodFromJson(Map<String, dynamic> json) {
  return Period(
    OperatingTime.fromJson(json['close'] as Map<String, dynamic>),
    OperatingTime.fromJson(json['open'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'close': instance.closeTime,
      'open': instance.openTime,
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
