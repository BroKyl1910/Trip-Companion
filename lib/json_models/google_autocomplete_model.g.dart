// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_autocomplete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAutocompleteResult _$GoogleAutocompleteResultFromJson(
    Map<String, dynamic> json) {
  return GoogleAutocompleteResult(
    predictions: (json['predictions'] as List)
        .map((e) => Prediction.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GoogleAutocompleteResultToJson(
        GoogleAutocompleteResult instance) =>
    <String, dynamic>{
      'predictions': instance.predictions,
    };

Prediction _$PredictionFromJson(Map<String, dynamic> json) {
  return Prediction(
    json['description'] as String,
    json['id'] as String,
    (json['matched_substrings'] as List)
        ?.map((e) =>
            e == null ? null : Substring.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['place_id'] as String,
    json['reference'] as String,
    json['structured_formatting'] == null
        ? null
        : StructuredFormatting.fromJson(
            json['structured_formatting'] as Map<String, dynamic>),
    (json['terms'] as List)
        ?.map(
            (e) => e == null ? null : Term.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['types'] as List)?.map((e) => e as String)?.toList(),
    json['distance_meters'] as int,
  );
}

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'matched_substrings': instance.matchedSubstrings,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'structured_formatting': instance.structuredFormatting,
      'terms': instance.terms,
      'types': instance.types,
      'distance_meters': instance.distanceMeters,
    };

Term _$TermFromJson(Map<String, dynamic> json) {
  return Term(
    json['offset'] as int,
    json['value'] as String,
  );
}

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'offset': instance.offset,
      'value': instance.value,
    };

StructuredFormatting _$StructuredFormattingFromJson(Map<String, dynamic> json) {
  return StructuredFormatting(
    json['main_text'] as String,
    (json['main_text_matched_substrings'] as List)
        .map((e) => Substring.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['secondary_text'] as String,
  );
}

Map<String, dynamic> _$StructuredFormattingToJson(
        StructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'main_text_matched_substrings': instance.mainTextMatchedSubstrings,
      'secondary_text': instance.secondaryText,
    };

Substring _$SubstringFromJson(Map<String, dynamic> json) {
  return Substring(
    json['length'] as int,
    json['offset'] as int,
  );
}

Map<String, dynamic> _$SubstringToJson(Substring instance) => <String, dynamic>{
      'length': instance.length,
      'offset': instance.offset,
    };
