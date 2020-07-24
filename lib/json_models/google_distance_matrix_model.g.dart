// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_distance_matrix_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleDistanceMatrix _$GoogleDistanceMatrixFromJson(Map<String, dynamic> json) {
  return GoogleDistanceMatrix(
    destinationAddresses: (json['destinationAddresses'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    originAddresses:
        (json['originAddresses'] as List)?.map((e) => e as String)?.toList(),
    rows: (json['rows'] as List)
        ?.map((e) => e == null
            ? null
            : DistanceMatrixRow.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$GoogleDistanceMatrixToJson(
        GoogleDistanceMatrix instance) =>
    <String, dynamic>{
      'destinationAddresses': instance.destinationAddresses,
      'originAddresses': instance.originAddresses,
      'rows': instance.rows,
      'status': instance.status,
    };

DistanceMatrixRow _$DistanceMatrixRowFromJson(Map<String, dynamic> json) {
  return DistanceMatrixRow(
    (json['elements'] as List)
        ?.map((e) => e == null
            ? null
            : GoogleElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DistanceMatrixRowToJson(DistanceMatrixRow instance) =>
    <String, dynamic>{
      'elements': instance.elements,
    };

GoogleElement _$GoogleElementFromJson(Map<String, dynamic> json) {
  return GoogleElement(
    json['distance'] == null
        ? null
        : TextValue.fromJson(json['distance'] as Map<String, dynamic>),
    json['duration'] == null
        ? null
        : TextValue.fromJson(json['duration'] as Map<String, dynamic>),
    json['status'] as String,
  );
}

Map<String, dynamic> _$GoogleElementToJson(GoogleElement instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'status': instance.status,
    };

TextValue _$TextValueFromJson(Map<String, dynamic> json) {
  return TextValue(
    json['text'] as String,
    (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$TextValueToJson(TextValue instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
