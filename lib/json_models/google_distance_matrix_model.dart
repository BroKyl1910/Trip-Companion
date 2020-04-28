import 'package:json_annotation/json_annotation.dart';

part 'google_distance_matrix_model.g.dart';

@JsonSerializable(nullable: true)
class GoogleDistanceMatrix {
  final List<String> destinationAddresses;
  final List<String> originAddresses;
  final List<DistanceMatrixRow> rows;
  final String status;

  GoogleDistanceMatrix({this.destinationAddresses, this.originAddresses, this.rows, this.status});

  factory GoogleDistanceMatrix.fromJson(Map<String, dynamic> json) => _$GoogleDistanceMatrixFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleDistanceMatrixToJson(this);
}

@JsonSerializable(nullable: true)
class DistanceMatrixRow {
  final List<GoogleElement> elements;

  DistanceMatrixRow(this.elements);
  factory DistanceMatrixRow.fromJson(Map<String, dynamic> json) => _$DistanceMatrixRowFromJson(json);
  Map<String, dynamic> toJson() => _$DistanceMatrixRowToJson(this);
}

@JsonSerializable(nullable: true)
class GoogleElement {
  final TextValue distance;
  final TextValue duration;
  final String status;

  GoogleElement(this.distance, this.duration, this.status);
  factory GoogleElement.fromJson(Map<String, dynamic> json) => _$GoogleElementFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleElementToJson(this);
}

@JsonSerializable(nullable: true)
class TextValue {
  final String text;
  final double value;

  TextValue(this.text, this.value);
  factory TextValue.fromJson(Map<String, dynamic> json) => _$TextValueFromJson(json);
  Map<String, dynamic> toJson() => _$TextValueToJson(this);
}
