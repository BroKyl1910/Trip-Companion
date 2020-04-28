import 'package:json_annotation/json_annotation.dart';

part 'google_autocomplete_model.g.dart';

@JsonSerializable(nullable: false)
class GoogleAutocompleteResult {
  final List<Prediction> predictions;
  GoogleAutocompleteResult({this.predictions});

  factory GoogleAutocompleteResult.fromJson(Map<String, dynamic> json) => _$GoogleAutocompleteResultFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAutocompleteResultToJson(this);
}

@JsonSerializable(nullable: true)
class Prediction {
  final String description;
  final String id;
  final List<Substring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;
  final int distanceMeters;

  Prediction(this.description, this.id, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types, this.distanceMeters);
  factory Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);
  Map<String, dynamic> toJson() => _$PredictionToJson(this);


  @override
  String toString() {
    return description;
  }
}
@JsonSerializable(nullable: false)
class Term {
  final int offset;
  final String value;

  Term(this.offset, this.value);
  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}

@JsonSerializable(nullable: false)
class StructuredFormatting {
  final String mainText;
  final List<Substring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting(this.mainText, this.mainTextMatchedSubstrings, this.secondaryText);
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => _$StructuredFormattingFromJson(json);
  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);
}

@JsonSerializable(nullable: false)
class Substring {
  final int length;
  final int offset;

  Substring(this.length, this.offset);
  factory Substring.fromJson(Map<String, dynamic> json) => _$SubstringFromJson(json);
  Map<String, dynamic> toJson() => _$SubstringToJson(this);
}