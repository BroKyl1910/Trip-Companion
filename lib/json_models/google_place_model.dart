import 'package:json_annotation/json_annotation.dart';

part 'google_place_model.g.dart';

@JsonSerializable(nullable: false)
class GooglePlaceResult {
  final Result result;
  GooglePlaceResult({this.result});

  factory GooglePlaceResult.fromJson(Map<String, dynamic> json) => _$GooglePlaceResultFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePlaceResultToJson(this);
}

@JsonSerializable(nullable: false)
class Result{
  final String formattedAddress;
  final String formattedPhoneNumber;
  final Geometry geometry;
  final String id;
  final String internationalPhoneNumber;
  final String name;
  final OpeningHours openingHours;
  final String placeId;
  final double rating;

  Result(this.formattedAddress, this.formattedPhoneNumber, this.geometry, this.id, this.internationalPhoneNumber, this.name, this.openingHours, this.placeId, this.rating);
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable(nullable: false)
class OpeningHours {
  final bool openNow;
  final List<Period> periods;

  OpeningHours(this.openNow, this.periods);
  factory OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable(nullable: false)
class Period {
  final OperatingTime closeTime;
  final OperatingTime openTime;

  Period(this.closeTime, this.openTime);
  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);
  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

@JsonSerializable(nullable: false)
class OperatingTime {
  final int day;
  final String time;

  OperatingTime(this.day, this.time);
  factory OperatingTime.fromJson(Map<String, dynamic> json) => _$OperatingTimeFromJson(json);
  Map<String, dynamic> toJson() => _$OperatingTimeToJson(this);
}

@JsonSerializable(nullable: false)
class Geometry {
  final Location location;

  Geometry(this.location);
  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable(nullable: false)
class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}